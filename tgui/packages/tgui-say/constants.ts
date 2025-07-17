/** Window sizes in pixels */
export enum WINDOW_SIZES {
  small = 30,
  medium = 50,
  large = 70,
  width = 380,
}

/** Line lengths for autoexpand */
export enum LINE_LENGTHS {
  small = 38,
  medium = 76,
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
