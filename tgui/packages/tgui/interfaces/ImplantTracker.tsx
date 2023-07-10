import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type TrackerData = {
  chem_implants: ChemImplant[];
  tracking_implants: TrackingImplant[];
};

type ChemImplant = {
  implanted_name: string;
  remaining_units: number;
  ref: string;
};

type TrackingImplant = {
  id: number;
  loc_display: string;
  ref: string;
};

export const ImplantTracker = (props, context) => {
  const { act, data } = useBackend<TrackerData>(context);

  return (
    <NtosWindow resizable width={800}>
      <NtosWindow.Content scrollable>
        <Section title="Chemical Implants">
          <Table>
            <Table.Row header>
              <Table.Cell>Implanted User</Table.Cell>
              <Table.Cell>Remaining Chemical Units</Table.Cell>
              <Table.Cell>Options</Table.Cell>
            </Table.Row>
            {data.chem_implants.map((chemimplant) => (
              <Table.Row key={chemimplant.ref}>
                <Table.Cell>{chemimplant.implanted_name}</Table.Cell>
                <Table.Cell>{chemimplant.remaining_units}u</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Inject 1u"
                    icon="tint"
                    onClick={() => act('inject1', { inject1: chemimplant.ref })}
                  />
                  <Button
                    content="Inject 5u"
                    icon="tint"
                    onClick={() => act('inject5', { inject5: chemimplant.ref })}
                  />
                  <Button
                    content="Inject 10u"
                    icon="tint"
                    onClick={() =>
                      act('inject10', { inject10: chemimplant.ref })
                    }
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Section title="Tracking Implants">
          <Table>
            <Table.Row header>
              <Table.Cell>Tracking ID</Table.Cell>
              <Table.Cell>Current Area</Table.Cell>
              <Table.Cell>Options</Table.Cell>
            </Table.Row>
            {data.tracking_implants.map((trackingimplant) => (
              <Table.Row key={trackingimplant.ref}>
                <Table.Cell>{trackingimplant.id}</Table.Cell>
                <Table.Cell>{trackingimplant.loc_display}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Message Implanted User"
                    icon="exclamation"
                    onClick={() => act('warn', { warn: trackingimplant.ref })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
