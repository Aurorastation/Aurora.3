/** Window sizes in pixels */
export enum WindowSize {
  Small = 30,
  Medium = 50,
  Large = 70,
  Width = 380,
}

/** Line lengths for autoexpand */
export enum LineLength {
  Small = 36,
  Medium = 70,
  Large = 104,
}

/**
 * Radio prefixes.
 * Displays the name in the left button, tags a css class.
 */
export const RADIO_PREFIXES = {
  '; ': 'Com',
  ':b ': 'io',
  ':c ': 'Cmd',
  ':e ': 'Engi',
  ':g ': 'Cling',
  ':m ': 'Med',
  ':n ': 'Sci',
  ':o ': 'AI',
  ':z ': 'Ent',
  ':s ': 'Sec',
  ':x ': 'Synd',
  ':u ': 'Supp',
  ':v ': 'Svc',
  ':y ': 'Hail',
  ':f ': 'Uncom',
  ':q ': 'Pen',
  ':t ': 'Merc',
  ':d ': 'Exped',
} as const;
