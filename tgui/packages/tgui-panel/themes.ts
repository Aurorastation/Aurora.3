/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const THEMES = ['light', 'dark'];

const COLORS = {
  DARK: {
    BG_BASE: '#212020',
    BG_SECOND: '#161515',
    BUTTON: '#414040',
    TEXT: '#A6A6A6',
  },
  LIGHT: {
    BG_BASE: '#EFEEEE',
    BG_SECOND: '#FFFFFF',
    BUTTON: '#FFFEFE',
    TEXT: '#000000',
  },
};

let setClientThemeTimer: null;

/**
 * Darkmode preference, originally by Kmc2000.
 *
 * This lets you switch client themes by using winset.
 *
 * If you change ANYTHING in interface/skin.dmf you need to change it here.
 *
 * There's no way round it. We're essentially changing the skin by hand.
 * It's painful but it works, and is the way Lummox suggested.
 */
export const setClientTheme = (name) => {
  // Transmit once for fast updates and again in a little while in case we won
  // the race against statbrowser init.
  clearInterval(setClientThemeTimer);
  Byond.command(`.output statbrowser:set_theme ${name}`);
  setClientThemeTimer = setTimeout(() => {
    Byond.command(`.output statbrowser:set_theme ${name}`);
  }, 1500);

  const themeColor = COLORS[name.toUpperCase()];
  if (!themeColor) {
    return;
  }

  return Byond.winset({
    // Main windows
    'infobuttons.background-color': themeColor.BG_BASE,
    'infobuttons.text-color': themeColor.TEXT,
    'infowindow.background-color': themeColor.BG_BASE,
    'infowindow.text-color': themeColor.TEXT,
    'info_and_buttons.background-color': themeColor.BG_BASE,
    'info.background-color': themeColor.BG_BASE,
    'info.text-color': themeColor.TEXT,
    'browseroutput.background-color': themeColor.BG_BASE,
    'browseroutput.text-color': themeColor.TEXT,
    'outputwindow.background-color': themeColor.BG_BASE,
    'outputwindow.text-color': themeColor.TEXT,
    'mainwindow.background-color': themeColor.BG_BASE,
    'split.background-color': themeColor.BG_BASE,
    // Buttons
    'changelog.background-color': themeColor.BUTTON,
    'changelog.text-color': themeColor.TEXT,
    'rulesb.background-color': themeColor.BUTTON,
    'rulesb.text-color': themeColor.TEXT,
    'wikib.background-color': themeColor.BUTTON,
    'wikib.text-color': themeColor.TEXT,
    'forumb.background-color': themeColor.BUTTON,
    'forumb.text-color': themeColor.TEXT,
    'discordb.background-color': themeColor.BUTTON,
    'discordb.text-color': themeColor.TEXT,
    'interfaceb.background-color': themeColor.BUTTON,
    'interfaceb.text-color': themeColor.TEXT,
    'reportbugb.background-color': themeColor.BUTTON,
    'reportbugb.text-color': themeColor.TEXT,
    // Status and verb tabs
    'output.background-color': themeColor.BG_BASE,
    'output.text-color': themeColor.TEXT,
    // Say, OOC, me Buttons etc.
    'saybutton.background-color': themeColor.BG_BASE,
    'saybutton.text-color': themeColor.TEXT,
    'oocbutton.background-color': themeColor.BG_BASE,
    'oocbutton.text-color': themeColor.TEXT,
    'mebutton.background-color': themeColor.BG_BASE,
    'mebutton.text-color': themeColor.TEXT,
    'hotkey_toggle.background-color': themeColor.BG_BASE,
    'hotkey_toggle.text-color': themeColor.TEXT,
    'asset_cache_browser.background-color': themeColor.BG_BASE,
    'asset_cache_browser.text-color': themeColor.TEXT,
    'tooltip.background-color': themeColor.BG_BASE,
    'tooltip.text-color': themeColor.TEXT,
    'input.background-color': themeColor.BG_SECOND,
    'input.text-color': themeColor.TEXT,
  });
};
