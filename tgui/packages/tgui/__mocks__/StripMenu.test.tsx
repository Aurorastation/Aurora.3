import { afterEach, beforeEach, describe, expect, it, spyOn } from 'bun:test';
import { cleanup, fireEvent, render, screen } from '@testing-library/react';
import * as actions from '../events/act';
import { gameDataAtom, resetStore, store } from '../events/store';
import { Radio } from '../interfaces/Radio';
import { StripMenu } from '../interfaces/StripMenu';

const equipment = {
  name: 'Test crewmember',
  busy: false,
  held: null,
  internals: false,
  can_toggle_internals: true,
  can_remove_splints: true,
  slots: [
    {
      id: 'back',
      key: 'back',
      label: 'Back',
      name: 'Active RIG',
      ref: 'rig-ref',
      removable: false,
      actions: [{ id: 'deactivate_rig', label: 'Deactivate RIG' }],
    },
    {
      id: 'uniform',
      key: 'uniform',
      label: 'Uniform',
      name: 'Jumpsuit',
      ref: 'uniform-ref',
      removable: true,
      actions: [
        { id: 'sensors', label: 'Set sensors' },
        { id: 'tie', label: 'Remove accessory' },
        { id: 'future_action', label: 'Another item action' },
      ],
    },
    {
      id: 'head',
      key: 'head',
      label: 'Head',
      name: null,
      ref: null,
      removable: true,
      actions: [],
    },
  ],
  species_actions: [{ id: 'headtail', label: 'Empty headtail storage' }],
};

describe('StripMenu', () => {
  const sendAct = spyOn(actions, 'sendAct');

  beforeEach(() => {
    sendAct.mockClear();
    store.set(gameDataAtom, equipment);
  });

  afterEach(() => {
    cleanup();
    resetStore();
  });

  it('allows alternate actions on an item that cannot be removed', () => {
    render(<StripMenu />);
    fireEvent.click(screen.getByLabelText('Back: Active RIG'));
    expect(sendAct).not.toHaveBeenCalled();
    fireEvent.click(screen.getByLabelText('Deactivate RIG'));
    expect(sendAct).toHaveBeenCalledWith('item_action', {
      slot: 'back',
      ref: 'rig-ref',
      id: 'deactivate_rig',
    });
  });

  it('supports arbitrary additional actions and species actions', () => {
    render(<StripMenu />);
    for (const action of equipment.slots[1].actions) {
      fireEvent.click(screen.getByLabelText(action.label));
      expect(sendAct).toHaveBeenLastCalledWith('item_action', {
        slot: 'uniform',
        ref: 'uniform-ref',
        id: action.id,
      });
    }
    fireEvent.click(screen.getByLabelText('Empty headtail storage'));
    expect(sendAct).toHaveBeenLastCalledWith('species', { id: 'headtail' });
  });

  it('disables every action while an interaction is in progress', () => {
    store.set(gameDataAtom, { ...equipment, busy: true, held: 'hat' });
    render(<StripMenu />);
    for (const label of [
      'Deactivate RIG',
      'Set sensors',
      'Head: empty',
      'Remove splints',
      'Empty headtail storage',
    ]) {
      fireEvent.click(screen.getByLabelText(label));
    }
    expect(sendAct).not.toHaveBeenCalled();
  });

  it('requires a held item to equip an empty slot and sends its empty reference', () => {
    const { unmount } = render(<StripMenu />);
    fireEvent.click(screen.getByLabelText('Head: empty'));
    expect(sendAct).not.toHaveBeenCalled();
    unmount();
    store.set(gameDataAtom, { ...equipment, held: 'hat' });
    render(<StripMenu />);
    fireEvent.click(screen.getByLabelText('Head: empty'));
    expect(sendAct).toHaveBeenCalledWith('slot', { slot: 'head', ref: null });
  });

  it('opens storage without stripping the equipped item', () => {
    store.set(gameDataAtom, {
      ...equipment,
      slots: [
        {
          ...equipment.slots[0],
          actions: [
            { id: 'open_storage', label: 'Open storage' },
            ...equipment.slots[0].actions,
          ],
        },
      ],
    });
    render(<StripMenu />);
    fireEvent.click(screen.getByLabelText('Open storage'));
    expect(sendAct).toHaveBeenCalledTimes(1);
    expect(sendAct).toHaveBeenCalledWith('item_action', {
      slot: 'back',
      ref: 'rig-ref',
      id: 'open_storage',
    });
    expect(screen.getByLabelText('Deactivate RIG')).toBeTruthy();
  });

  it('opens the radio menu on an equipped headset', () => {
    store.set(gameDataAtom, {
      ...equipment,
      slots: [
        {
          id: '9',
          key: 'left_ear',
          label: 'Left ear',
          name: 'Headset',
          ref: 'headset-ref',
          removable: true,
          actions: [{ id: 'open_radio', label: 'Radio menu' }],
        },
      ],
    });
    render(<StripMenu />);
    fireEvent.click(screen.getByLabelText('Radio menu'));
    expect(sendAct).toHaveBeenCalledWith('item_action', {
      slot: '9',
      ref: 'headset-ref',
      id: 'open_radio',
    });
  });

  it('provides speaker and microphone toggles in the radio menu', () => {
    store.set(gameDataAtom, {
      speaker: true,
      mic_status: false,
      freq: 1459,
      rawfreq: 1459,
      default_freq: 1459,
      min_freq: 1441,
      max_freq: 1489,
      mic_cut: false,
      spk_cut: false,
    });
    render(<Radio />);
    fireEvent.click(screen.getByLabelText('Turn speaker off'));
    expect(sendAct).toHaveBeenLastCalledWith('toggle_listen');
    fireEvent.click(screen.getByLabelText('Turn microphone on'));
    expect(sendAct).toHaveBeenLastCalledWith('toggle_talk');
  });

  it('uses sprites and retains hand labels for held items', () => {
    store.set(gameDataAtom, {
      ...equipment,
      slots: [
        {
          id: '6',
          key: 'right_hand',
          label: 'Right hand',
          name: 'Wrench',
          ref: 'wrench-ref',
          icon: 'test-image',
          removable: true,
          actions: [],
        },
      ],
    });
    const { container } = render(<StripMenu />);
    expect(
      container.querySelector('.StripMenu__item')?.getAttribute('src'),
    ).toBe('data:image/png;base64,test-image');
    expect(screen.getByText('R')).toBeTruthy();
    fireEvent.click(screen.getByLabelText('Right hand: Wrench'));
    expect(sendAct).toHaveBeenCalledWith('slot', {
      slot: '6',
      ref: 'wrench-ref',
    });
  });

  it('allows individual removal and item actions from searched pockets', () => {
    store.set(gameDataAtom, {
      ...equipment,
      slots: [
        {
          id: '16',
          key: 'left_pocket',
          label: 'Left pocket',
          name: 'Wallet',
          ref: 'wallet-ref',
          removable: true,
          actions: [{ id: 'open_storage', label: 'Open storage' }],
        },
      ],
    });
    const { container } = render(<StripMenu />);
    expect(container.querySelector('.StripMenu__marker')).toBeNull();
    fireEvent.click(screen.getByLabelText('Open storage'));
    expect(sendAct).toHaveBeenLastCalledWith('item_action', {
      slot: '16',
      ref: 'wallet-ref',
      id: 'open_storage',
    });
    fireEvent.click(screen.getByLabelText('Left pocket: Wallet'));
    expect(sendAct).toHaveBeenLastCalledWith('slot', {
      slot: '16',
      ref: 'wallet-ref',
    });
  });

  it('marks concealed pockets and blocks covered slots and their actions', () => {
    store.set(gameDataAtom, {
      ...equipment,
      slots: [
        {
          id: '16',
          key: 'left_pocket',
          label: 'Left pocket',
          hidden: true,
          actions: [],
        },
        { ...equipment.slots[1], obscured: true, name: null, ref: null },
      ],
    });
    const { container } = render(<StripMenu />);
    fireEvent.click(screen.getByLabelText('Uniform: covered'));
    expect(sendAct).not.toHaveBeenCalled();
    expect(screen.queryByLabelText('Remove accessory')).toBeNull();
    expect(container.querySelectorAll('.StripMenu__marker').length).toBe(2);
    fireEvent.click(
      screen.getByLabelText('Left pocket: concealed - search pockets'),
    );
    expect(sendAct).toHaveBeenCalledWith('general', { id: 'pockets' });
  });
});
