/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { FONTS_DISABLED } from './constants';
import {
  MAX_CONFIGURABLE_MESSAGES,
  MIN_CONFIGURABLE_MESSAGES,
} from '../chat/constants';
import { chatRenderer } from '../chat/renderer';
import { setClientTheme } from './themes';
import type { SettingsState } from './types';

let statFontTimer: NodeJS.Timeout;
let statTabsTimer: NodeJS.Timeout;
let overrideFontFamily: string | undefined;
let overrideFontSize: string;

export function clampMaxMessages(maxMessages: number): number {
  return Math.min(
    MAX_CONFIGURABLE_MESSAGES,
    Math.max(MIN_CONFIGURABLE_MESSAGES, maxMessages),
  );
}

/** Updates the global CSS rule to override the font family and size. */
function updateGlobalOverrideRule(): void {
  let fontFamily: string | null = null;

  if (overrideFontFamily !== undefined) {
    fontFamily = overrideFontFamily;
  }

  document.documentElement.style.setProperty('font-family', fontFamily);
  document.body.style.setProperty('font-family', fontFamily);
  document.body.style.setProperty('font-size', overrideFontSize);
}

function setGlobalFontSize(
  fontSize: string | number,
  statFontSize: string | number,
  statLinked: boolean,
): void {
  overrideFontSize = `${fontSize}px`;

  // Used solution from theme.ts
  clearInterval(statFontTimer);
  Byond.command(
    `.output statbrowser:set_font_size ${statLinked ? fontSize : statFontSize}px`,
  );
  statFontTimer = setTimeout(() => {
    Byond.command(
      `.output statbrowser:set_font_size ${statLinked ? fontSize : statFontSize}px`,
    );
  }, 1500);
}

function setGlobalFontFamily(fontFamily: string): void {
  overrideFontFamily = fontFamily === FONTS_DISABLED ? undefined : fontFamily;
}

function setStatTabsStyle(style: string): void {
  clearInterval(statTabsTimer);
  Byond.command(`.output statbrowser:set_tabs_style ${style}`);
  statTabsTimer = setTimeout(() => {
    Byond.command(`.output statbrowser:set_tabs_style ${style}`);
  }, 1500);
}

export function generalSettingsHandler(update: SettingsState): void {
  update.maxMessages = clampMaxMessages(update.maxMessages);
  chatRenderer.setMaxMessages(update.maxMessages);

  // Set client theme
  const theme = update?.theme;
  if (theme) {
    setClientTheme(theme);
  }

  // Update stat panel settings
  setStatTabsStyle(update.statTabsStyle);

  // Update global UI font size
  setGlobalFontSize(update.fontSize, update.statFontSize, update.statLinked);
  setGlobalFontFamily(update.fontFamily);
  updateGlobalOverrideRule();
}
