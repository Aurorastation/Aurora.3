export type PaperCodeLanguage = {
  key: string;
  short?: string;
  style?: string;
};

export type PaperCodeContext = {
  background_color?: string;
  date: string;
  disabled_tags?: string[];
  docs_image_host?: string;
  encode?: boolean;
  font_color?: string;
  font_face?: string;
  font_style?: 'bold' | 'italic';
  languages?: PaperCodeLanguage[];
  limited?: boolean;
  max_length?: number;
  preserve_whitespace?: boolean;
  raw?: boolean;
  signature?: string;
  signature_font?: string;
  station: string;
  strip_html?: boolean;
  tajdate: string;
  tajtime: string;
  time: string;
  trim?: boolean;
};

const encodeHtml = (text: string) =>
  text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');

const replace = (text: string, token: string, value: string) =>
  text.split(token).join(value);

/** Client-side equivalent of pencode2html for live, zero-RPC previews. */
export function renderPaperCode(source: string, context: PaperCodeContext) {
  let text = source || '';
  if (context.max_length) {
    text = text.slice(0, context.max_length);
  }
  if (context.strip_html) {
    text = text.replace(/<[^>]*>/g, '').replace(/[\n\t]/g, '#');
  } else if (context.raw) {
    // File Manager documents historically store unencoded papercode source.
  } else if (context.encode !== false) {
    text = encodeHtml(text);
  } else {
    text = text.replace(/[<>]/g, ' ');
  }
  if (!context.preserve_whitespace) {
    text = text.replace(/[\n\t]/g, ' ');
  }
  if (context.trim !== false) {
    text = text.trim();
  }

  for (const tag of context.disabled_tags || []) {
    text = replace(text, `[${tag}]`, '');
    text = replace(text, `[/${tag}]`, '');
  }

  if (context.signature !== undefined) {
    text = replace(
      text,
      '[sign]',
      `<font face="${encodeHtml(context.signature_font || 'Verdana')}">${context.signature}</font>`,
    );
  }

  const languages = new Map(
    (context.languages || []).map((language) => [language.key, language]),
  );
  text = text.replace(
    /\[lang=([#_a-zA-Z0-9^])](.*?)\[\/lang]/g,
    (_match, key: string, content: string) => {
      const language = languages.get(key);
      if (!language) {
        return '';
      }
      const label = language.short ? `(${encodeHtml(language.short)}) ` : '';
      return `<span class="${encodeHtml(language.style || '')} understood">${label}${content}</span>`;
    },
  );

  if (context.font_face) {
    const openingStyle = context.font_style === 'bold' ? '<b>' : context.font_style === 'italic' ? '<i>' : '';
    const closingStyle = context.font_style === 'bold' ? '</b>' : context.font_style === 'italic' ? '</i>' : '';
    text = `<font face="${encodeHtml(context.font_face)}" color="${encodeHtml(context.font_color || 'black')}">${openingStyle}${text}${closingStyle}</font>`;
  }

  const basicTags: Array<[string, string]> = [
    ['[b]', '<b>'], ['[/b]', '</b>'], ['[i]', '<i>'], ['[/i]', '</i>'],
    ['[u]', '<u>'], ['[/u]', '</u>'], ['[large]', '<font size="4">'],
    ['[/large]', '</font>'], ['[small]', '<font size="1">'], ['[/small]', '</font>'],
  ];
  for (const [token, html] of basicTags) {
    text = replace(text, token, html);
  }
  text = replace(text, '[station]', encodeHtml(context.station || ''));
  text = text.replace(/\[redacted](.*?)\[\/redacted]/g, (_match, content: string) =>
    `<span class="redacted">${'|'.repeat(content.length)}</span>`,
  );
  if (context.limited) {
    return text;
  }

  const tags: Array<[string, string]> = [
    ['\n', '<br>'], ['[center]', '<center>'], ['[/center]', '</center>'],
    ['[br]', '<br>'], ['[field]', '<span class="paper_field"></span>'],
    ['[h1]', '<h1>'], ['[/h1]', '</h1>'], ['[h2]', '<h2>'], ['[/h2]', '</h2>'],
    ['[h3]', '<h3>'], ['[/h3]', '</h3>'], ['[*]', '<li>'], ['[hr]', '<hr>'],
    ['[list]', '<ul>'], ['[/list]', '</ul>'],
    ['[table]', '<table border="1" cellspacing="0" cellpadding="3" style="border: 1px solid black;">'],
    ['[/table]', '</td></tr></table>'], ['[grid]', '<table>'], ['[/grid]', '</td></tr></table>'],
    ['[row]', '</td><tr>'], ['[cell]', '<td>'],
  ];
  for (const [token, html] of tags) {
    text = replace(text, token, html);
  }

  const images: Record<string, string> = {
    logo_scc: 'scclogo.png', logo_scc_small: 'scclogo_small.png',
    logo_nt: 'nanotrasenlogo.png', logo_nt_small: 'nanotrasenlogo_small.png',
    logo_zh: 'zhlogo.png', logo_zh_small: 'zhlogo_small.png',
    logo_idris: 'idrislogo.png', logo_idris_small: 'idrislogo_small.png',
    logo_eridani: 'eridanilogo.png', logo_eridani_small: 'eridanilogo_small.png',
    logo_zavod: 'zavodlogo.png', logo_zavod_small: 'zavodlogo_small.png',
    logo_hp_large: 'hplogolarge.png', logo_hp: 'hplogo.png', logo_hp_small: 'hplogo_small.png',
    logo_orion: 'orionlogo.png', logo_orion_small: 'orionlogo_small.png',
    logo_pmcg: 'pmcglogo.png', logo_pmcg_small: 'pmcglogo_small.png',
    flag_be: 'beflag.png', flag_be_small: 'beflag_small.png',
    flag_elyra: 'elyraflag.png', flag_elyra_small: 'elyraflag_small.png',
    flag_sol: 'solflag.png', flag_sol_small: 'solflag_small.png',
    flag_coc: 'cocflag.png', flag_coc_small: 'cocflag_small.png',
    flag_dom: 'domflag.png', flag_dom_small: 'domflag_small.png',
    flag_nralakk: 'nralakkflag.png', flag_nralakk_small: 'nralakkflag_small.png',
    flag_pra: 'praflag.png', flag_pra_small: 'praflag_small.png',
    flag_dpra: 'dpraflag.png', flag_dpra_small: 'dpraflag_small.png',
    flag_nka: 'nkaflag.png', flag_nka_small: 'nkaflag_small.png',
    flag_izweski: 'izweskiflag.png', flag_izweski_small: 'izweskiflag_small.png',
    logo_golden: 'goldenlogo.png', logo_golden_small: 'goldenlogo_small.png',
    logo_pvpolice: 'pvpolicelogo.png', logo_pvpolice_small: 'pvpolicelogo_small.png',
    logo_outereyes: 'outereyeslogo.png', logo_outereyes_small: 'outereyeslogo_small.png',
    twinsuns: 'twinsuns.png', twinsuns_small: 'twinsuns_small.png',
    raskara_sigil: 'raskara_sigil.png', raskara_sigil_small: 'raskara_sigil_small.png',
  };
  for (const [tag, image] of Object.entries(images)) {
    text = replace(text, `[${tag}]`, `<img src="${image}">`);
  }
  text = replace(text, '[barcode]', '<img src="barcode0.png">');
  text = replace(text, '[time]', encodeHtml(context.time || ''));
  text = replace(text, '[date]', encodeHtml(context.date || ''));
  text = replace(text, '[tajtime]', encodeHtml(context.tajtime || ''));
  text = replace(text, '[tajdate]', encodeHtml(context.tajdate || ''));
  text = replace(text, '[cr]', '电');
  text = replace(text, '[editorbr]', '<br>');
  text = text.replace(
    /\[image id=([\w]*?\.[\w]*?)]/g,
    (_match, image: string) =>
      `<img style="display:block;width:90%;" src="${encodeHtml(context.docs_image_host || '')}${encodeHtml(image)}">`,
  );
  return text;
}
