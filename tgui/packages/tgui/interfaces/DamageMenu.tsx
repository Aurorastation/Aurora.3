import { Button, Section, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type DamageData = {
  limbs: Organ[];
  organs: Organ[];
};

type Organ = {
  name: string;
  present: BooleanLike;
};

export const DamageMenu = (props) => {
  const { act, data } = useBackend<DamageData>();

  return (
    <Window theme="admin">
      <Window.Content scrollable>
        <Section title="Limbs">
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Action</Table.Cell>
            </Table.Row>
            {data.limbs.map((limb) =>
              limb.present ? (
                <Table.Row key={data.limbs.indexOf(limb)}>
                  <Table.Cell key={limb.name}>{limb.name}</Table.Cell>
                  <Table.Cell>
                    <Button
                      content="Brute"
                      onClick={() =>
                        act('limb', { action: 'brute', name: limb.name })
                      }
                    />
                    <Button
                      content="Burn"
                      onClick={() =>
                        act('limb', { action: 'burn', name: limb.name })
                      }
                    />
                    <Button
                      content="Infection"
                      onClick={() =>
                        act('limb', { action: 'infection', name: limb.name })
                      }
                    />
                    <Button
                      content="Shatter"
                      onClick={() =>
                        act('limb', { action: 'shatter', name: limb.name })
                      }
                    />
                    <Button
                      content="Arterial"
                      onClick={() =>
                        act('limb', { action: 'arterial', name: limb.name })
                      }
                    />
                    <Button
                      content="Sever"
                      onClick={() =>
                        act('limb', { action: 'sever', name: limb.name })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ) : (
                ''
              ),
            )}
          </Table>
        </Section>
        <Section title="Organs">
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Action</Table.Cell>
            </Table.Row>
            {data.organs.map((organ) =>
              organ.present ? (
                <Table.Row key={data.organs.indexOf(organ)}>
                  <Table.Cell key={organ.name}>{organ.name}</Table.Cell>
                  <Table.Cell>
                    <Button
                      content="Damage"
                      onClick={() =>
                        act('organ', { action: 'damage', name: organ.name })
                      }
                    />
                    <Button
                      content="Infection"
                      onClick={() =>
                        act('organ', { action: 'infection', name: organ.name })
                      }
                    />
                    <Button
                      content="Bruise"
                      onClick={() =>
                        act('organ', { action: 'bruise', name: organ.name })
                      }
                    />
                    <Button
                      content="Break"
                      onClick={() =>
                        act('organ', { action: 'break', name: organ.name })
                      }
                    />
                    <Button
                      content="Remove"
                      onClick={() =>
                        act('organ', { action: 'remove', name: organ.name })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ) : (
                ''
              ),
            )}
          </Table>
        </Section>
        <Section title="Miscellaneous - Minor">
          <Button
            content="Seizure"
            color="yellow"
            icon="wind"
            onClick={() => act('misc', { action: 'seizure' })}
          />
        </Section>
        <Section title="Miscellaneous - Major">
          <Button
            content="Toggle Wind"
            color="red"
            icon="wind"
            onClick={() => act('misc', { action: 'wind' })}
          />
          <Button
            content="Heart Attack"
            color="red"
            icon="heart-pulse"
            tooltip="Stops the target's heart and pushes them into critical shock. Healthy, full-blood, quickly-treated targets may recover. Untreated or already-compromised targets are likely to die."
            onClick={() => act('misc', { action: 'heart attack' })}
          />
          <Button
            content="Gigashatter"
            color="red"
            icon="bone"
            tooltip="Applies Shatter (bone fracture) to all limbs simultaneously."
            onClick={() => act('misc', { action: 'gigashatter' })}
          />
          <Button
            content="Kill"
            color="red"
            icon="skull-crossbones"
            tooltip="Kills the target mob. Instant death, no cause."
            onClick={() => act('misc', { action: 'kill' })}
          />
          <Button
            content="Gib"
            color="red"
            icon="splotch"
            tooltip="Splat."
            onClick={() => act('misc', { action: 'gib' })}
          />
          <Button
            content="Dust"
            color="red"
            icon="exclamation-triangle"
            tooltip="Turns the target mob into dust."
            onClick={() => act('misc', { action: 'dust' })}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
