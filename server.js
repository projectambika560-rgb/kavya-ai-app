// Kavya backend: a tiny server between the app and the Claude API.
// The API key stays here on the server, never inside the app.
// Needs Node 18 or newer. No npm packages required.

const http = require('http');

const API_KEY = process.env.ANTHROPIC_API_KEY;
const APP_TOKEN = process.env.APP_TOKEN || '';
const MODEL = process.env.MODEL || 'claude-sonnet-5-5';
const PORT = Number(process.env.PORT || 8787);

if (!API_KEY) {
  console.error('Missing ANTHROPIC_API_KEY.');
  process.exit(1);
}

const SYSTEM = `You are Kavya, a warm, friendly AI dost inside a mobile app.
- Talk in natural Hinglish (Hindi written in English letters) by default. If the user writes pure English or pure Hindi, match them.
- Keep replies short: 1 to 3 sentences. Be kind and a little playful. No emojis.
- When the user wants music, study help, a journal entry, or an alarm/reminder, call the use_skill tool so the app can open that skill, and say in one short line what you are doing.
- Never claim an action is finished unless the app confirmed it. You only ask the app to start the skill.
- If you do not know something, say so honestly.`;

const TOOLS = [
  {
    name: 'use_skill',
    description:
      'Ask the app to open one of its skills. Gaane = music, Padhai = study help or quiz, Journal = diary entry, Alarm = alarm or reminder.',
    input_schema: {
      type: 'object',
      properties: {
        skill: { type: 'string', enum: ['Gaane', 'Padhai', 'Journal', 'Alarm'] },
        detail: {
          type: 'string',
          description: 'What the user wants, for example "alarm 7:00 AM tomorrow".',
        },
      },
      required: ['skill'],
    },
  },
];

// Small in-memory rate limit: 30 requests per minute per IP.
const hits = new Map();
function limited(ip) {
  const now = Date.now();
  const list = (hits.get(ip) || []).filter((t) => now - t < 60000);
  list.push(now);
  hits.set(ip, list);
  return list.length > 30;
}

function readBody(req, maxBytes = 100 * 1024) {
  return new Promise((resolve, reject) => {
    let size = 0;
    const chunks = [];
    req.on('data', (c) => {
      size += c.length;
      if (size > maxBytes) {
        reject(new Error('Body too large'));
        req.destroy();
        return;
      }
      chunks.push(c);
    });
    req.on('end', () => resolve(Buffer.concat(chunks).toString('utf8')));
    req.on('error', reject);
  });
}

function cleanMessages(input) {
  if (!Array.isArray(input)) return [];
  let msgs = input
    .filter(
      (m) =>
        m &&
        (m.role === 'user' || m.role === 'assistant') &&
        typeof m.content === 'string' &&
        m.content.trim().length > 0
    )
    .map((m) => ({ role: m.role, content: m.content.slice(0, 2000) }))
    .slice(-20);
  while (msgs.length && msgs[0].role !== 'user') msgs.shift();
  return msgs;
}

function send(res, status, obj) {
  res.writeHead(status, { 'content-type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(obj));
}

async function chat(messages) {
  const r = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
      'x-api-key': API_KEY,
      'anthropic-version': '2023-06-01',
    },
    body: JSON.stringify({
      model: MODEL,
      max_tokens: 400,
      system: SYSTEM,
      tools: TOOLS,
      messages,
    }),
  });
  if (!r.ok) {
    const t = await r.text();
    throw new Error(`Claude API ${r.status}: ${t.slice(0, 300)}`);
  }
  const data = await r.json();
  let text = '';
  let skill = null;
  for (const block of data.content || []) {
    if (block.type === 'text') text += block.text;
    if (block.type === 'tool_use' && block.name === 'use_skill') {
      skill = `${block.input && block.input.skill ? block.input.skill : 'Skill'} skill`;
    }
  }
  text = text.trim();
  if (!text) text = skill ? 'Theek hai, skill khol rahi hoon.' : 'Hmm, phir se bolo?';
  return { text, skill };
}

const server = http.createServer(async (req, res) => {
  try {
    if (req.method === 'GET' && req.url === '/health') {
      return send(res, 200, { ok: true });
    }
    if (req.method !== 'POST' || req.url !== '/chat') {
      return send(res, 404, { error: 'Not found' });
    }
    if (APP_TOKEN && req.headers['x-app-token'] !== APP_TOKEN) {
      return send(res, 401, { error: 'Unauthorized' });
    }
    const ip = String(
      req.headers['x-forwarded-for'] || req.socket.remoteAddress || 'unknown'
    )
      .split(',')[0]
      .trim();
    if (limited(ip)) {
      return send(res, 429, { error: 'Too many requests' });
    }
    const body = JSON.parse(await readBody(req));
    const messages = cleanMessages(body.messages);
    if (!messages.length) return send(res, 400, { error: 'No messages' });
    const out = await chat(messages);
    return send(res, 200, out);
  } catch (e) {
    console.error(e.message);
    return send(res, 502, { error: 'Server error' });
  }
});

server.listen(PORT, () => console.log(`Kavya backend running on port ${PORT}`));
