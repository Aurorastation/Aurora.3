import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section, Table, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export type LawData = {
  ion_law_nr: string;
  ion_law: string;
  zeroth_law: string;
  inherent_law: string;
  supplied_law: string;
  supplied_law_position: number;

  zeroth_laws: Law[];
  ion_laws: Law[];
  inherent_laws: Law[];
  supplied_laws: Law[];
  law_sets: LawSet[];

  isAI: BooleanLike;
  isMalf: BooleanLike;
  isSlaved: BooleanLike;
  isAdmin: BooleanLike;
  view: number;

  channel: string;
  channels: Channel[];
};

type Law = {
  law: string;
  index: number;
  state: string;
  ref: string;
};

type Channel = {
  channel: string;
};

type LawSet = {
  name: string;
  header: string;
  ref: string;
  laws: LawSetLaws;
};

type LawSetLaws = {
  zeroth_laws: Law[];
  ion_laws: Law[];
  inherent_laws: Law[];
  supplied_laws: Law[];
};

export const LawManager = (props, context) => {
  const { act, data } = useBackend<LawData>(context);

  return (
    <NtosWindow resizable width={800}>
      <NtosWindow.Content scrollable>
        <Tabs>
          <Tabs.Tab
            onClick={() => act('set_view', { set_view: 0 })}
            selected={data.view === 0}>
            Law Management
          </Tabs.Tab>
          <Tabs.Tab
            onClick={() => act('set_view', { set_view: 1 })}
            selected={data.view === 1}>
            Law Sets
          </Tabs.Tab>
        </Tabs>
        {data.view ? <LawSets /> : <LawManagement />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const LawManagement = (props, context) => {
  const { act, data } = useBackend<LawData>(context);

  return (
    <Section>
      {data.isSlaved ? (
        <NoticeBox color="green">Slaved to {data.isSlaved}.</NoticeBox>
      ) : (
        ''
      )}
      {data.ion_laws && data.ion_laws.length ? <Ionlaws /> : ''}
      {data.inherent_laws && data.inherent_laws.length ? <InherentLaws /> : ''}
      {data.supplied_laws && data.supplied_laws.length ? <SuppliedLaws /> : ''}
      <LabeledList>
        <LabeledList.Item label="State on Channel">
          {data.channels && data.channels.length
            ? data.channels.map((channel) => (
              <Button
                key={channel.channel}
                content={channel.channel}
                selected={data.channel === channel.channel}
                onClick={() =>
                  act('law_channel', { law_channel: channel.channel })
                }
              />
            ))
            : ''}
        </LabeledList.Item>
        <LabeledList.Item label="State Laws">
          <Button
            content="State"
            icon="microphone"
            onClick={() => act('state_laws')}
          />
        </LabeledList.Item>
      </LabeledList>
      {data.isMalf ? <AddLaws /> : ''}
    </Section>
  );
};

export const AddLaws = (props, context) => {
  const { act, data } = useBackend<LawData>(context);

  return (
    <Section title="Add Laws">
      <Table>
        <Table.Row header>
          <Table.Cell>Type</Table.Cell>
          <Table.Cell>Law</Table.Cell>
          <Table.Cell>Index</Table.Cell>
          <Table.Cell>Edit</Table.Cell>
          <Table.Cell>Add</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Zero</Table.Cell>
          <Table.Cell>{data.zeroth_law}</Table.Cell>
          <Table.Cell>N/A</Table.Cell>
          <Table.Cell>
            <Button content="Edit" onClick={() => act('change_zeroth_law')} />
          </Table.Cell>
          <Table.Cell>
            <Button content="Add" onClick={() => act('add_zeroth_law')} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Ion</Table.Cell>
          <Table.Cell>{data.ion_law}</Table.Cell>
          <Table.Cell>N/A</Table.Cell>
          <Table.Cell>
            <Button content="Edit" onClick={() => act('change_ion_law')} />
          </Table.Cell>
          <Table.Cell>
            <Button content="Add" onClick={() => act('add_ion_law')} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Inherent</Table.Cell>
          <Table.Cell>{data.inherent_law}</Table.Cell>
          <Table.Cell>N/A</Table.Cell>
          <Table.Cell>
            <Button content="Edit" onClick={() => act('change_inherent_law')} />
          </Table.Cell>
          <Table.Cell>
            <Button content="Add" onClick={() => act('add_inherent_law')} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Supplied</Table.Cell>
          <Table.Cell>{data.supplied_law}</Table.Cell>
          <Table.Cell>{data.supplied_law_position}</Table.Cell>
          <Table.Cell>
            <Button content="Edit" onClick={() => act('change_supplied_law')} />
          </Table.Cell>
          <Table.Cell>
            <Button content="Add" onClick={() => act('add_supplied_law')} />
          </Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};

export const Ionlaws = (props, context) => {
  const { act, data } = useBackend<LawData>(context);

  return (
    <Section title={data.ion_law_nr + ' Laws'}>
      <Table>
        <Table.Row header>
          <Table.Cell>Index</Table.Cell>
          <Table.Cell>Law</Table.Cell>
          <Table.Cell>State</Table.Cell>
          {data.isMalf ? (
            <>
              <Table.Cell>Edit</Table.Cell>
              <Table.Cell>Delete</Table.Cell>
            </>
          ) : (
            ''
          )}
        </Table.Row>
        {data.ion_laws.map((law) => (
          <Table.Row key={law.index}>
            <Table.Cell>{law.index}</Table.Cell>
            <Table.Cell>{law.law}</Table.Cell>
            <Table.Cell>
              <Button
                content={law.state ? 'Yes' : 'No'}
                color={law.state ? 'green' : 'red'}
                onClick={() =>
                  act('state_law', { state_law: !law.state, ref: law.ref })
                }
              />
            </Table.Cell>
            {data.isMalf ? (
              <>
                <Table.Cell>
                  <Button
                    content="Edit"
                    onClick={() => act('edit_law', { edit_law: law.ref })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content="Delete"
                    color="red"
                    onClick={() => act('delete_law', { delete_law: law.ref })}
                  />
                </Table.Cell>
              </>
            ) : (
              ''
            )}
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const InherentLaws = (props, context) => {
  const { act, data } = useBackend<LawData>(context);

  return (
    <Section title="Inherent Laws">
      <Table>
        <Table.Row header>
          <Table.Cell>Index</Table.Cell>
          <Table.Cell>Law</Table.Cell>
          <Table.Cell>State</Table.Cell>
          {data.isMalf ? (
            <>
              <Table.Cell>Edit</Table.Cell>
              <Table.Cell>Delete</Table.Cell>
            </>
          ) : (
            ''
          )}
        </Table.Row>
        {data.zeroth_laws && data.zeroth_laws.length
          ? data.zeroth_laws.map((law) => (
            <Table.Row key={law.ref}>
              <Table.Cell>
                <Box color="red" as="span">
                  0
                </Box>
              </Table.Cell>
              <Table.Cell>{law.law}</Table.Cell>
              <Table.Cell>
                <Button
                  content={law.state ? 'Yes' : 'No'}
                  color={law.state ? 'green' : 'red'}
                  onClick={() =>
                    act('state_law', { state_law: !law.state, ref: law.ref })
                  }
                />
              </Table.Cell>
              {data.isMalf ? (
                <>
                  <Table.Cell>
                    <Button
                      content="Edit"
                      onClick={() => act('edit_law', { edit_law: law.ref })}
                    />
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      content="Delete"
                      color="red"
                      onClick={() => act('delete_law', { delete_law: law.ref })}
                    />
                  </Table.Cell>
                </>
              ) : (
                ''
              )}
            </Table.Row>
          ))
          : ''}
        {data.inherent_laws.map((law) => (
          <Table.Row key={law.index}>
            <Table.Cell>{law.index}</Table.Cell>
            <Table.Cell>{law.law}</Table.Cell>
            <Table.Cell>
              <Button
                content={law.state ? 'Yes' : 'No'}
                color={law.state ? 'green' : 'red'}
                onClick={() =>
                  act('state_law', { state_law: !law.state, ref: law.ref })
                }
              />
            </Table.Cell>
            {data.isMalf ? (
              <>
                <Table.Cell>
                  <Button
                    content="Edit"
                    onClick={() => act('edit_law', { edit_law: law.ref })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content="Delete"
                    color="red"
                    onClick={() => act('delete_law', { delete_law: law.ref })}
                  />
                </Table.Cell>
              </>
            ) : (
              ''
            )}
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const SuppliedLaws = (props, context) => {
  const { act, data } = useBackend<LawData>(context);

  return (
    <Section title="Supplied Laws">
      <Table>
        <Table.Row header>
          <Table.Cell>Index</Table.Cell>
          <Table.Cell>Law</Table.Cell>
          <Table.Cell>State</Table.Cell>
          {data.isMalf ? (
            <>
              <Table.Cell>Edit</Table.Cell>
              <Table.Cell>Delete</Table.Cell>
            </>
          ) : (
            ''
          )}
        </Table.Row>
        {data.supplied_laws.map((law) => (
          <Table.Row key={law.index}>
            <Table.Cell>{law.index}</Table.Cell>
            <Table.Cell>{law.law}</Table.Cell>
            <Table.Cell>
              <Button
                content={law.state ? 'Yes' : 'No'}
                color={law.state ? 'green' : 'red'}
                onClick={() =>
                  act('state_law', { state_law: !law.state, ref: law.ref })
                }
              />
            </Table.Cell>
            {data.isMalf ? (
              <>
                <Table.Cell>
                  <Button
                    content="Edit"
                    onClick={() => act('edit_law', { edit_law: law.ref })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content="Delete"
                    color="red"
                    onClick={() => act('delete_law', { delete_law: law.ref })}
                  />
                </Table.Cell>
              </>
            ) : (
              ''
            )}
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const LawSets = (props, context) => {
  const { act, data } = useBackend<LawData>(context);

  return (
    <Section
      title="Law Sets"
      buttons={
        data.isAI ? (
          <Button
            content="Notify Law Change"
            onClick={() => act('notify_laws')}
          />
        ) : (
          ''
        )
      }>
      <NoticeBox>
        Remember: Stating laws other than those currently loading may be grounds
        for decomissioning.
        <Box textAlign="center">-Stellar Corporate Conglomerate</Box>
      </NoticeBox>
      {data.law_sets && data.law_sets.length
        ? data.law_sets.map((set) => (
          <Section
            title={set.name}
            key={set.name}
            buttons={
              <>
                <Button
                  content="State Laws"
                  onClick={() =>
                    act('state_law_set', { state_law_set: set.ref })
                  }
                />
                {data.isMalf ? (
                  <Button
                    content="Add Laws"
                    color="red"
                    onClick={() =>
                      act('transfer_laws', { transfer_laws: set.ref })
                    }
                  />
                ) : (
                  ''
                )}
              </>
            }>
            <Box>{set.header}</Box>
            <Table>
              <Table.Row header>
                <Table.Cell>Index</Table.Cell>
                <Table.Cell>Law</Table.Cell>
              </Table.Row>
              {set.laws.ion_laws && set.laws.ion_laws.length
                ? set.laws.ion_laws.map((law) => (
                  <Table.Row key={law.ref}>
                    <Table.Cell>{law.index}</Table.Cell>
                    <Table.Cell>{law.law}</Table.Cell>
                  </Table.Row>
                ))
                : ''}
              {(set.laws.inherent_laws && set.laws.inherent_laws.length) ||
              (set.laws.zeroth_laws && set.laws.zeroth_laws.length) ? (
                <>
                  {set.laws.zeroth_laws.length
                    ? set.laws.zeroth_laws.map((law) => (
                      <Table.Row key={law.ref}>
                        <Table.Cell>{law.index}</Table.Cell>
                        <Table.Cell>{law.law}</Table.Cell>
                      </Table.Row>
                    ))
                    : ''}
                  {set.laws.inherent_laws.map((law) => (
                    <Table.Row key={law.ref}>
                      <Table.Cell>{law.index}</Table.Cell>
                      <Table.Cell>{law.law}</Table.Cell>
                    </Table.Row>
                  ))}
                </>
              ) : (
                ''
              )}
              {set.laws.supplied_laws && set.laws.supplied_laws.length
                ? set.laws.supplied_laws.map((law) => (
                  <Table.Row key={law.ref}>
                    <Table.Cell>{law.index}</Table.Cell>
                    <Table.Cell>{law.law}</Table.Cell>
                  </Table.Row>
                ))
                : ''}
            </Table>
          </Section>
        ))
        : ''}
    </Section>
  );
};
