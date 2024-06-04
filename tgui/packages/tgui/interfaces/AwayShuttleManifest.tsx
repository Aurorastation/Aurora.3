import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Flex, Table, Collapsible } from '../components';
import { NtosWindow } from '../layouts';

export type AwayShuttleData = {
  shuttle_manifest: ShuttleCrew[];
  active_record: ShuttleCrew;
  shuttle_assignments: ShuttleAssignment[];
};

type ShuttleCrew = {
  name: string;
  shuttle: string;
  pilot: Boolean;
  lead: Boolean;
  id: number;
};

type ShuttleAssignment = {
  shuttle: string;
  destination: string;
  heading: number;
  mission: string;
  departure_time: string;
  return_time: string;
}

export const AwayShuttleManifest = (props, context) => {
  const { act, data } = useBackend<AwayShuttleData>(context);

  return (
    <NtosWindow resizable width={900} height={600}>
      <NtosWindow.Content scrollable>
        {' '}
        {data.active_record ? <ManifestEntryEdit /> : <AllShuttles />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ManifestEntryEdit = (props, context) => {
  const { act, data } = useBackend<AwayShuttleData>(context);

  return (
    <Section
      title="Edit Manifest"
      buttons={
        <>
          <Button content="Back" onClick={() => act('am_menu')} />
          <Button
            content="Save"
            color="green"
            onClick={() => act('saveentry')}
          />
          <Button
            content="Delete"
            color="red"
            onClick={() => act('deleteentry')}
          />
        </>
      }>
      <LabeledList>
        <LabeledList.Item label="Name">
          {data.active_record.name}&nbsp;
          <Button
            icon="user"
            tooltip="Use a name found in the records."
            onClick={() => act('editentryname')}
          />
          <Button
            icon="question"
            tooltip="Use a custom name."
            onClick={() => act('editentrynamecustom')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Shuttle">
          {data.active_record.shuttle}&nbsp;
          <Button
            icon="info"
            tooltip="Change the shuttle for this entry."
            onClick={() => act('editentryshuttle')}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const AllShuttles = (props, context) => {
  const { act, data } = useBackend<AwayShuttleData>(context);

  return (
    <>
      <Collapsible title="SCCV Canary" color="blue">
        <Section
          title="SCCV Canary"
          buttons={
            <Button icon="plus" color="green" onClick={() => act('addentry')} />
          }>
          {data.shuttle_assignments.filter((m => m.shuttle === 'SCCV Canary')).map((ShuttleAssignment) => (
          <Table.Row key={ShuttleAssignment.shuttle}>
            <Table.Cell>
              <Flex.Item>
                Destination:
                <Button
                  content={ShuttleAssignment.destination}
                  onClick={() =>
                    act('editdestination', { editdestination: ShuttleAssignment.shuttle })
                  }
                />
                Heading:
                <Button
                  content={ShuttleAssignment.heading}
                  onClick={() =>
                    act('editheading', { editheading: ShuttleAssignment.shuttle })
                  }
                />
                Mission:
                <Button
                  content={ShuttleAssignment.mission}
                  onClick={() =>
                    act('editmission', { editmission: ShuttleAssignment.shuttle })
                  }
                />
                Departure Time:
                <Button
                  content={ShuttleAssignment.departure_time}
                  onClick={() =>
                    act('editdeparturetime', { editdeparturetime: ShuttleAssignment.shuttle })
                  }
                />
                Return Time:
                <Button
                  content={ShuttleAssignment.return_time}
                  onClick={() =>
                    act('editreturntime', { editreturntime: ShuttleAssignment.shuttle })
                  }
                />
              </Flex.Item>
            </Table.Cell>
          </Table.Row>))}
          {data.shuttle_manifest && data.shuttle_manifest.length ? (
            <Flex>
              <Table>
                <Table.Row header>
                  <Table.Cell>Name</Table.Cell>
                </Table.Row>
                {data.shuttle_manifest
                  .filter((m) => m.shuttle === 'SCCV Canary')
                  .map((ShuttleCrew) => (
                    <Table.Row key={ShuttleCrew.id}>
                      <Table.Cell>
                        <Flex.Item>
                          <Button
                            icon = {ShuttleCrew.lead ? "star" : null}
                            color={ShuttleCrew.lead ? 'green' : 'blue'}
                            onClick={() =>
                              act('editlead', { editlead: ShuttleCrew.id })
                            }
                          />
                          <Button
                            content={ShuttleCrew.name}
                            onClick={() =>
                              act('editentry', { editentry: ShuttleCrew.id })
                            }
                          />
                          <Button
                            content={ShuttleCrew.pilot ? 'P' : 'O'}
                            color={ShuttleCrew.pilot ? 'green' : 'blue'}
                            onClick={() =>
                              act('editpilot', { editpilot: ShuttleCrew.id })
                            }
                          />
                        </Flex.Item>
                      </Table.Cell>
                    </Table.Row>
                  ))}
              </Table>
            </Flex>
          ) : (
            <NoticeBox>No crew detected.</NoticeBox>
          )}
        </Section>
      </Collapsible>
      <Collapsible title="SCCV Intrepid" color="purple">
        <Section
          title="SCCV Intrepid"
          buttons={
            <Button icon="plus" color="green" onClick={() => act('addentry')} />
          }>
          {data.shuttle_assignments.filter((m => m.shuttle === 'SCCV Intrepid')).map((ShuttleAssignment) => (
          <Table.Row key={ShuttleAssignment.shuttle}>
            <Table.Cell>
              <Flex.Item>
              Destination:
                <Button
                  content={ShuttleAssignment.destination}
                  onClick={() =>
                    act('editdestination', { editdestination: ShuttleAssignment.shuttle })
                  }
                />
                Heading:
                <Button
                  content={ShuttleAssignment.heading}
                  onClick={() =>
                    act('editheading', { editheading: ShuttleAssignment.shuttle })
                  }
                />
                Mission:
                <Button
                  content={ShuttleAssignment.mission}
                  onClick={() =>
                    act('editmission', { editmission: ShuttleAssignment.shuttle })
                  }
                />
                Departure Time:
                <Button
                  content={ShuttleAssignment.departure_time}
                  onClick={() =>
                    act('editdeparturetime', { editdeparturetime: ShuttleAssignment.shuttle })
                  }
                />
                Return Time:
                <Button
                  content={ShuttleAssignment.return_time}
                  onClick={() =>
                    act('editreturntime', { editreturntime: ShuttleAssignment.shuttle })
                  }
                />
              </Flex.Item>
            </Table.Cell>
          </Table.Row>))}
          {data.shuttle_manifest && data.shuttle_manifest.length ? (
            <Flex>
              <Table>
                <Table.Row header>
                  <Table.Cell>Name</Table.Cell>
                </Table.Row>
                {data.shuttle_manifest
                  .filter((m) => m.shuttle === 'SCCV Intrepid')
                  .map((ShuttleCrew) => (
                    <Table.Row key={ShuttleCrew.id}>
                      <Table.Cell>
                        <Flex.Item>
                          <Button
                            icon = {ShuttleCrew.lead ? "star" : null}
                            color={ShuttleCrew.lead ? 'green' : 'blue'}
                            onClick={() =>
                              act('editlead', { editlead: ShuttleCrew.id })
                            }
                          />
                          <Button
                            content={ShuttleCrew.name}
                            onClick={() =>
                              act('editentry', { editentry: ShuttleCrew.id })
                            }
                          />
                          <Button
                            content={ShuttleCrew.pilot ? 'P' : 'O'}
                            color={ShuttleCrew.pilot ? 'green' : 'blue'}
                            onClick={() =>
                              act('editpilot', { editpilot: ShuttleCrew.id })
                            }
                          />
                        </Flex.Item>
                      </Table.Cell>
                    </Table.Row>
                  ))}
              </Table>
            </Flex>
          ) : (
            <NoticeBox>No crew detected.</NoticeBox>
          )}
        </Section>
      </Collapsible>
      <Collapsible title="SCCV Spark" color="brown">
        <Section
          title="SCCV Spark"
          buttons={
            <Button icon="plus" color="green" onClick={() => act('addentry')} />
          }>
          {data.shuttle_assignments.filter((m => m.shuttle === 'SCCV Spark')).map((ShuttleAssignment) => (
          <Table.Row key={ShuttleAssignment.shuttle}>
            <Table.Cell>
              <Flex.Item>
              Destination:
                <Button
                  content={ShuttleAssignment.destination}
                  onClick={() =>
                    act('editdestination', { editdestination: ShuttleAssignment.shuttle })
                  }
                />
                Heading:
                <Button
                  content={ShuttleAssignment.heading}
                  onClick={() =>
                    act('editheading', { editheading: ShuttleAssignment.shuttle })
                  }
                />
                Mission:
                <Button
                  content={ShuttleAssignment.mission}
                  onClick={() =>
                    act('editmission', { editmission: ShuttleAssignment.shuttle })
                  }
                />
                Departure Time:
                <Button
                  content={ShuttleAssignment.departure_time}
                  onClick={() =>
                    act('editdeparturetime', { editdeparturetime: ShuttleAssignment.shuttle })
                  }
                />
                Return Time:
                <Button
                  content={ShuttleAssignment.return_time}
                  onClick={() =>
                    act('editreturntime', { editreturntime: ShuttleAssignment.shuttle })
                  }
                />
              </Flex.Item>
            </Table.Cell>
          </Table.Row>))}
          {data.shuttle_manifest && data.shuttle_manifest.length ? (
            <Flex>
              <Table>
                <Table.Row header>
                  <Table.Cell>Name</Table.Cell>
                </Table.Row>
                {data.shuttle_manifest
                  .filter((m) => m.shuttle === 'SCCV Spark')
                  .map((ShuttleCrew) => (
                    <Table.Row key={ShuttleCrew.id}>
                      <Table.Cell>
                        <Flex.Item>
                          <Button
                            icon = {ShuttleCrew.lead ? "star" : null}
                            color={ShuttleCrew.lead ? 'green' : 'blue'}
                            onClick={() =>
                              act('editlead', { editlead: ShuttleCrew.id })
                            }
                          />
                          <Button
                            content={ShuttleCrew.name}
                            onClick={() =>
                              act('editentry', { editentry: ShuttleCrew.id })
                            }
                          />
                          <Button
                            content={ShuttleCrew.pilot ? 'P' : 'O'}
                            color={ShuttleCrew.pilot ? 'green' : 'blue'}
                            onClick={() =>
                              act('editpilot', { editpilot: ShuttleCrew.id })
                            }
                          />
                        </Flex.Item>
                      </Table.Cell>
                    </Table.Row>
                  ))}
              </Table>
            </Flex>
          ) : (
            <NoticeBox>No crew detected.</NoticeBox>
          )}
        </Section>
      </Collapsible>
    </>
  );
};
