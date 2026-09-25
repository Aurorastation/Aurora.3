/** Window sizes in pixels */
export enum WindowSize {
  Small = 30,
  Medium = 50,
  Large = 70,
  Width = 462,
}

/** Line lengths for autoexpand */
export enum LineLength {
  Small = 40,
  Medium = 78,
  Large = 118,
}

/**
 * Radio prefixes.
 * Displays the name in the left button, tags a css class.
 */
export const RADIO_PREFIXES = {
  ':r ': 'REar',
  ':l ': 'LEar',
  ':i ': 'Int',
  ':h ': 'Dept',
  ':+ ': 'Spec',
  ':a ': 'Hive',
  ':b ': 'Burg',
  ':c ': 'Cmd',
  ':d ': 'Exp',
  ':e ': 'Engi',
  ':f ': 'Navy',
  ':g ': 'Cling',
  ':j ': 'Blue',
  ':k ': 'Jock',
  ':m ': 'Med',
  ':n ': 'Sci',
  ':p ': 'AI',
  ':q ': 'Penal',
  ':s ': 'Sec',
  ':t ': 'Merc',
  ':u ': 'Ops',
  ':v ': 'Svc',
  ':w ': 'Whsp',
  ':x ': 'Raid',
  ':y ': 'Hail',
  ':z ': 'Ent',
} as const;
