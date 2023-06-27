import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type NTOSMainData = {
  programs: NTProgram[];
  services: NTService[];
};

type NTProgram = {
  filename: string;
  desc: string;
  autorun: BooleanLike;
  running: BooleanLike;
};

type NTService = {
  filename: string;
  desc: string;
  running: BooleanLike;
};

export const NTOSMain = (props, context) => {
  const { act, data } = useBackend<NTOSMainData>(context);
  const { programs = [], services = [] } = data;
  return (
    <NtosWindow title={'NtOS Main Menu'} width={400} height={500}>
      <NtosWindow.Content scrollable>
        <Section title="NtOS Program Directory">
          <Table>
            {programs.map((program) => {
              return (
                <Table.Row key={program.filename}>
                  <Table.Cell>
                    <Button
                      fluid
                      key={program.filename}
                      content={program.desc}
                      color="transparent"
                      selected={program.running}
                      onClick={() => act('PC_runprogram', program)}
                    />
                  </Table.Cell>
                  <Table.Cell collapsing>
                    {!!program.running && (
                      <Button
                        color="transparent"
                        icon="times"
                        tooltip="Close Program"
                        tooltipPosition="left"
                        onClick={() => act('PC_killprogram', program)}
                      />
                    )}
                  </Table.Cell>
                </Table.Row>
              );
            })}
          </Table>
        </Section>
        <Section collapsing title="NtOS Services">
          <Table>
            {services.map((service) => {
              return (
                <Table.Row key={service.filename}>
                  <Table.Cell>
                    <Button
                      fluid
                      key={service.filename}
                      content={service.desc}
                      color="transparent"
                      selected={service.running}
                      onClick={() =>
                        act('PC_toggleservice', {
                          service_to_toggle: service.filename,
                        })
                      }
                    />
                  </Table.Cell>
                  <Table.Cell collapsing>
                    {!!service.running && (
                      <Button
                        color="transparent"
                        icon="times"
                        tooltip="Disable Service"
                        tooltipPosition="left"
                        onClick={() =>
                          act('PC_toggleservice', {
                            service_to_toggle: service.filename,
                          })
                        }
                      />
                    )}
                  </Table.Cell>
                </Table.Row>
              );
            })}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
