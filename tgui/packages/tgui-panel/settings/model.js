/**
 * @file
 */
import { createUuid } from 'common/uuid';

export const createHighlightSetting = (obj) => ({
  id: createUuid(),
  highlightText: '',
  highlightColor: '#ffdd44',
  highlightWholeMessage: true,
  backgroundHighlightColor: '#ffdd44',
  backgroundHighlightOpacity: 10,
  matchWord: false,
  matchCase: false,
  ...obj,
});

export const createDefaultHighlightSetting = (obj) =>
  createHighlightSetting({
    id: 'default',
    ...obj,
  });
