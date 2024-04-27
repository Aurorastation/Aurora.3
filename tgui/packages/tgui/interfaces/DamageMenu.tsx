import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { Window } from '../layouts';

export type DamageData = {
  limbs: Organ[];
  organs: Organ[];
};

type Organ = {
  name: string;
  present: BooleanLike;
};

export const DamageMenu = (props, context) => {
  const { act, data } = useBackend<DamageData>(context);

  return (
    <Window resizable theme="admin">
      <Window.Content scrollable>
        <Section title="Limbs">
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Action</Table.Cell>
            </Table.Row>
            {data.limbs.map((limb) =>
              limb.present ? (
                <Table.Row>
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
              )
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
                <Table.Row>
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
              )
            )}
          </Table>
        </Section>
        <Section title="Miscellaneous">
          <Button
            content="Toggle Wind"
            color="red"
            icon="wind"
            onClick={() => act('misc', { action: 'wind' })}
          />
          <Button
            content="Gigashatter"
            color="red"
            icon="bone"
            onClick={() => act('misc', { action: 'gigashatter' })}
          />
          <Button
            content="Kill"
            color="red"
            icon="skull-crossbones"
            onClick={() => act('misc', { action: 'kill' })}
          />
          <Button
            content="Gib"
            color="red"
            icon="splotch"
            onClick={() => act('misc', { action: 'gib' })}
          />
          <Button
            content="Dust"
            color="red"
            icon="exclamation-triangle"
            onClick={() => act('misc', { action: 'dust' })}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
