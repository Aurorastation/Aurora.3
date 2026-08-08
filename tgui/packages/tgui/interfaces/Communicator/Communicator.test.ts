import { describe, expect, it } from 'bun:test';

import { FormatAddress, SortUsersByName } from './helpers';

describe('Communicator helpers', () => {
  it('formats every alphanumeric communicator number character', () => {
    expect(FormatAddress('FC00-call-HOME-z9!')).toBe('fc00:call:home:z9');
  });

  it('limits communicator numbers to four groups', () => {
    expect(FormatAddress('fc00123456789012overflow')).toBe(
      'fc00:1234:5678:9012',
    );
  });

  it('sorts contacts without mutating backend data', () => {
    const contacts = [
      { address: 'fc00:0000:0000:0002', username: 'Zulu' },
      { address: 'fc00:0000:0000:0001', username: 'Alpha' },
    ];
    const sorted = SortUsersByName(contacts);

    expect(sorted.map((contact) => contact.username)).toEqual([
      'Alpha',
      'Zulu',
    ]);
    expect(contacts[0].username).toBe('Zulu');
  });
});
