/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { createAction } from 'tgui/backend';

export const toggleKitchenSink = createAction('debug/toggleKitchenSink');
export const toggleDebugLayout = createAction('debug/toggleDebugLayout');
export const openExternalBrowser = createAction('debug/openExternalBrowser');
