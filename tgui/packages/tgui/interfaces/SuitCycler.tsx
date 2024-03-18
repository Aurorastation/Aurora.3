import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type SuitCyclerData = {
  in_use: BooleanLike;
  locked: BooleanLike;
  emagged: BooleanLike;
  has_access: BooleanLike;
  can_repair: BooleanLike;
  model_text: string;
  radiation_level: number;
  target_department: string;
  department_change: BooleanLike;
  target_species: string;
  species_change: BooleanLike;
  helmet: SuitObject;
  suit: SuitObject;
  boots: SuitObject;
  mask: SuitObject;
};

type SuitObject = {
  name: string;
  damage: number;
};

export const SuitCycler = (props, context) => {
  const { act, data } = useBackend<SuitCyclerData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Locking Panel">
          {data.in_use ? (
            <NoticeBox>
              The {data.model_text ? data.model_text + ' ' : ''}suit cycler is
              currently in use. Please wait...
            </NoticeBox>
          ) : data.locked ? (
            <Box>
              <NoticeBox>
                The {data.model_text ? data.model_text + ' ' : ''}suit cycler is
                currently locked. Please contact your system administrator.
              </NoticeBox>
              <Button
                disabled={data.in_use || !data.has_access}
                content="Unlock"
                icon="lock-open"
                onClick={() => act('toggle_lock')}
              />
            </Box>
          ) : (
            <Box>
              <NoticeBox>
                Welcome to the {data.model_text ? data.model_text + ' ' : ''}
                suit cycler control panel.
              </NoticeBox>
              <Button
                disabled={data.in_use || !data.has_access}
                content="Lock"
                icon="lock"
                onClick={() => act('toggle_lock')}
              />
            </Box>
          )}
        </Section>
        <Section title="Suit Components">
          <LabeledList>
            <LabeledList.Item label="Helmet">
              <Button
                disabled={data.in_use || data.locked || !data.helmet}
                content={data.helmet ? data.helmet.name : 'None'}
                icon="hat-cowboy"
                onClick={() => act('eject_helmet')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Suit">
              <Button
                disabled={data.in_use || data.locked || !data.suit}
                content={data.suit ? data.suit.name : 'None'}
                icon="shirt"
                onClick={() => act('eject_suit')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Boots">
              <Button
                disabled={data.in_use || data.locked || !data.boots}
                content={data.boots ? data.boots.name : 'None'}
                icon="shoe-prints"
                onClick={() => act('eject_boots')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Mask">
              <Button
                disabled={data.in_use || data.locked || !data.mask}
                content={data.mask ? data.mask.name : 'None'}
                icon="mask-ventilator"
                onClick={() => act('eject_mask')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Actions">
          {data.suit?.damage ? (
            <Box pb={1}>
              <NoticeBox>
                Suit integrity compromised, advising repairs.
              </NoticeBox>
              <Button
                disabled={data.in_use || data.locked || !data.can_repair}
                content={
                  data.can_repair ? 'Repair' : 'Repair (Cycler Not Capable)'
                }
                icon="screwdriver-wrench"
                onClick={() => act('repair_suit')}
              />
            </Box>
          ) : null}
          <Box pb={1}>
            <h4>UV Decontamination</h4>
            <LabeledList>
              <LabeledList.Item label="UV Decontamination Systems">
                {data.emagged ? 'SYSTEM ERROR' : 'READY'}
              </LabeledList.Item>
              <LabeledList.Item label="Output Level">
                {data.radiation_level}
              </LabeledList.Item>
            </LabeledList>
            <Box pt={1}>
              <Button
                disabled={data.in_use || data.locked}
                content="Select Power Level"
                icon="bolt-lightning"
                onClick={() => act('select_rad_level')}
              />
              <Button
                disabled={data.in_use || data.locked}
                content="Begin Decontamination Cycle"
                icon="shower"
                onClick={() => act('begin_decontamination')}
              />
            </Box>
          </Box>
          <Box>
            <h4>Customization</h4>
            <LabeledList>
              <LabeledList.Item label="Target Department">
                <Button
                  disabled={
                    data.in_use || data.locked || !data.department_change
                  }
                  content={data.target_department}
                  icon="city"
                  onClick={() => act('select_department')}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Target Species">
                <Button
                  disabled={data.in_use || data.locked || !data.species_change}
                  content={data.target_species}
                  icon="person"
                  onClick={() => act('select_species')}
                />
              </LabeledList.Item>
            </LabeledList>
            <Box pt={1}>
              <Button
                disabled={data.in_use || data.locked}
                content="Apply Customization Routine"
                icon="play"
                onClick={() => act('apply_paintjob')}
              />
            </Box>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
