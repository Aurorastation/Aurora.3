// Body-grid layout inspired by ParadiseSS13/Paradise#24618.
import { Box, Button, Icon, Image } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type EquipmentAction = { id: string; label: string };
type EquipmentSlot = {
  id: string;
  key: string;
  label: string;
  name: string | null;
  ref: string | null;
  icon?: string;
  hidden?: BooleanLike;
  obscured?: BooleanLike;
  removable: BooleanLike;
  actions: EquipmentAction[];
};
export type StripMenuData = {
  name: string;
  busy: BooleanLike;
  active_slot?: string;
  held: string | null;
  internals: BooleanLike;
  can_toggle_internals: BooleanLike;
  can_remove_splints: BooleanLike;
  sensors?: string;
  slots: EquipmentSlot[];
  species_actions: EquipmentAction[];
};

type SlotLayout = {
  row: number;
  column: number;
  image?: string;
  icon?: string;
  hand?: string;
};
const SLOT_LAYOUT: Record<string, SlotLayout> = {
  eyes: { row: 1, column: 1, image: 'glasses' },
  head: { row: 1, column: 2, image: 'head' },
  right_ear: { row: 1, column: 3, image: 'ears' },
  mask: { row: 2, column: 2, image: 'mask' },
  left_ear: { row: 2, column: 3, image: 'ears' },
  handcuffs: { row: 2, column: 4, icon: 'handcuffs' },
  legcuffs: { row: 2, column: 5, icon: 'link' },
  uniform: { row: 3, column: 1, image: 'uniform' },
  suit: { row: 3, column: 2, image: 'suit' },
  gloves: { row: 3, column: 3, image: 'gloves' },
  right_hand: { row: 3, column: 4, image: 'hand_r', hand: 'R' },
  left_hand: { row: 3, column: 5, image: 'hand_l', hand: 'L' },
  pants: { row: 4, column: 1, image: 'uniform' },
  shoes: { row: 4, column: 2, image: 'shoes' },
  wrists: { row: 4, column: 3, icon: 'link' },
  right_pocket: { row: 4, column: 4, image: 'pocket' },
  left_pocket: { row: 4, column: 5, image: 'pocket' },
  suit_storage: { row: 5, column: 1, image: 'suit_storage' },
  id: { row: 5, column: 2, image: 'id' },
  belt: { row: 5, column: 3, image: 'belt' },
  back: { row: 5, column: 4, image: 'back' },
};

// Unknown actions still work, using a generic icon and their backend-supplied label.
const ACTION_ICONS: Record<string, string> = {
  open_storage: 'box-open',
  open_radio: 'headset',
  sensors: 'microchip',
  tie: 'ribbon',
  mask: 'mask-face',
  tank: 'gauge',
  activate_rig: 'power-off',
  deactivate_rig: 'power-off',
  headtail: 'head-side-virus',
};

export const StripMenu = () => {
  const { act, data } = useBackend<StripMenuData>();
  const extraSlots = data.slots.filter((slot) => !SLOT_LAYOUT[slot.key]);
  return (
    <Window
      title={`Stripping ${data.name}`}
      width={380}
      height={420}
      theme="nologo"
    >
      <Window.Content className="StripMenu" scrollable>
        <Box className="StripMenu__grid">
          {data.slots.map((slot) => {
            const layout = SLOT_LAYOUT[slot.key] || {
              row: 6 + Math.floor(extraSlots.indexOf(slot) / 5),
              column: (extraSlots.indexOf(slot) % 5) + 1,
              icon: 'box',
            };
            const label = slot.obscured
              ? `${slot.label}: covered`
              : slot.hidden
                ? `${slot.label}: concealed - search pockets`
                : slot.name
                  ? `${slot.label}: ${slot.name}`
                  : `${slot.label}: empty`;
            const disabled =
              !!data.busy ||
              !!slot.obscured ||
              (!slot.hidden && (slot.name ? !slot.removable : !data.held));
            return (
              <Box
                key={slot.id}
                className="StripMenu__slot"
                style={{ gridRow: layout.row, gridColumn: layout.column }}
              >
                <Button
                  className={`StripMenu__tile ${slot.name && !slot.removable ? 'StripMenu__tile--fixed' : ''} ${data.busy && (data.active_slot === slot.id || (slot.hidden && data.active_slot === 'pockets')) ? 'StripMenu__tile--active' : ''}`}
                  aria-label={label}
                  tooltip={
                    slot.name && !slot.removable
                      ? `${label} (cannot be removed)`
                      : label
                  }
                  disabled={disabled}
                  onClick={() =>
                    slot.hidden
                      ? act('general', { id: 'pockets' })
                      : act('slot', { slot: slot.id, ref: slot.ref })
                  }
                >
                  {layout.image && (
                    <Image
                      className="StripMenu__silhouette"
                      src={resolveAsset(`inventory-${layout.image}.png`)}
                    />
                  )}
                  {slot.obscured || slot.hidden ? (
                    <Icon
                      className="StripMenu__marker"
                      name={slot.obscured ? 'ban' : 'eye-slash'}
                    />
                  ) : slot.icon ? (
                    <Image
                      className="StripMenu__item"
                      src={`data:image/png;base64,${slot.icon}`}
                    />
                  ) : layout.icon ? (
                    <Icon
                      className="StripMenu__placeholder"
                      name={layout.icon}
                    />
                  ) : null}
                  {layout.hand && (
                    <Box
                      className={`StripMenu__hand StripMenu__hand--${layout.hand}`}
                    >
                      {layout.hand}
                    </Box>
                  )}
                </Button>
                {!slot.obscured && !slot.hidden && (
                  <Box
                    className={
                      slot.actions.length > 4
                        ? 'StripMenu__actions StripMenu__actions--many'
                        : 'StripMenu__actions'
                    }
                  >
                    {slot.actions.map((action, index) => (
                      <Button
                        key={action.id}
                        className={`StripMenu__action StripMenu__action--${index}`}
                        icon={ACTION_ICONS[action.id] || 'gear'}
                        aria-label={action.label}
                        tooltip={
                          action.id === 'sensors' && data.sensors
                            ? `${action.label}: ${data.sensors}`
                            : action.label
                        }
                        disabled={!!data.busy}
                        onClick={() =>
                          act('item_action', {
                            slot: slot.id,
                            ref: slot.ref,
                            id: action.id,
                          })
                        }
                      />
                    ))}
                  </Box>
                )}
              </Box>
            );
          })}
          {!!data.can_toggle_internals && (
            <Box
              className="StripMenu__slot"
              style={{ gridRow: 1, gridColumn: 4 }}
            >
              <Button
                className="StripMenu__tile StripMenu__utility"
                icon="lungs"
                selected={!!data.internals}
                aria-label={
                  data.internals ? 'Disable internals' : 'Enable internals'
                }
                tooltip={
                  data.internals ? 'Disable internals' : 'Enable internals'
                }
                disabled={!!data.busy || !data.can_toggle_internals}
                onClick={() => act('general', { id: 'internals' })}
              />
            </Box>
          )}
          {!!data.can_remove_splints && (
            <Box
              className="StripMenu__slot"
              style={{ gridRow: 1, gridColumn: 5 }}
            >
              <Button
                className="StripMenu__tile StripMenu__utility"
                icon="bandage"
                aria-label="Remove splints"
                tooltip="Remove splints"
                disabled={!!data.busy}
                onClick={() => act('general', { id: 'splints' })}
              />
            </Box>
          )}
          {data.species_actions.map((action, index) => (
            <Box
              key={action.id}
              className="StripMenu__slot"
              style={{
                gridRow:
                  index === 0
                    ? 5
                    : 6 +
                      Math.ceil(extraSlots.length / 5) +
                      Math.floor((index - 1) / 5),
                gridColumn: index === 0 ? 5 : ((index - 1) % 5) + 1,
              }}
            >
              <Button
                className="StripMenu__tile StripMenu__utility"
                icon={ACTION_ICONS[action.id] || 'gear'}
                aria-label={action.label}
                tooltip={action.label}
                disabled={!!data.busy}
                onClick={() => act('species', { id: action.id })}
              />
            </Box>
          ))}
        </Box>
        <Box
          className="StripMenu__status"
          color={data.busy ? 'average' : 'label'}
        >
          {data.busy ? (
            <>
              <Icon name="spinner" spin mr={1} />
              Interacting - stay close and still.
            </>
          ) : data.held ? (
            `Holding: ${data.held}`
          ) : (
            'Hold an item to equip an empty slot.'
          )}
        </Box>
      </Window.Content>
    </Window>
  );
};
