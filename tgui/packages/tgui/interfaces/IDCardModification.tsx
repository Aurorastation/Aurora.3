import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Collapsible, Divider, Flex, LabeledList, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export type IDData = {
  station_name: string;
  assignments: BooleanLike;
  have_id_slot: BooleanLike;
  have_printer: BooleanLike;
  authenticated: BooleanLike;
  centcom_access: BooleanLike;

  has_id: BooleanLike;
  id_account_number: number;
  id_rank: string;
  id_owner: string;
  id_name: string;

  all_centcom_access: Access[];
  regions: Region[];

  command_support_jobs: Job[];
  engineering_jobs: Job[];
  medical_jobs: Job[];
  science_jobs: Job[];
  security_jobs: Job[];
  cargo_jobs: Job[];
  service_jobs: Job[];
  civilian_jobs: Job[];
  centcom_jobs: Job[];
};

type Access = {
  desc: string;
  ref: string;
  allowed: BooleanLike;
};

type Region = {
  name: string;
  accesses: Access[];
};

type Job = {
  target_rank: string;
  job: string;
};

export const IDCardModification = (props, context) => {
  const { act, data } = useBackend<IDData>(context);

  return (
    <NtosWindow resizable width={650} height={700}>
      <NtosWindow.Content scrollable>
        <Section title="Identification Input">
          {!data.has_id ? (
            <NoticeBox>Please insert an ID to continue.</NoticeBox>
          ) : (
            ''
          )}
          <LabeledList>
            <LabeledList.Item label="Target Identity">
              <Button
                content={data.has_id ? data.id_name : '------'}
                icon="credit-card"
                onClick={() => act('eject')}
              />
            </LabeledList.Item>
          </LabeledList>
          {data.has_id && data.authenticated ? <AccessModification /> : ''}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const AccessModification = (props, context) => {
  const { act, data } = useBackend<IDData>(context);

  return (
    <Section title="Access Modification">
      <LabeledList>
        <LabeledList.Item label="Registered Name">
          <Button
            content={data.id_owner}
            icon="edit"
            onClick={() => act('edit', { name: 1 })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Idris Bank Account Number">
          <Button
            content={
              data.id_account_number === 0
                ? 'Unregistered'
                : data.id_account_number
            }
            icon="edit"
            onClick={() => act('edit', { account: 1 })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Suspend">
          <Button
            icon="gavel"
            color="red"
            onClick={() => act('suspend')}
            disabled={data.id_rank === 'Suspended'}
          />
        </LabeledList.Item>
      </LabeledList>
      <Section title="Assignments">
        <Collapsible content="Collapse" open>
          <LabeledList>
            <LabeledList.Item label="Custom" labelColor="white">
              <Button
                content="Captain"
                color="blue"
                disabled={data.id_rank === 'Captain'}
                onClick={() => act('assign', { assign_target: 'Captain' })}
              />
              <Button
                content="Custom"
                color="white"
                onClick={() => act('assign', { assign_target: 'Custom' })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Command Support" labelColor="#114DC1">
              {data.command_support_jobs.map((job) => (
                <Button
                  key={job.job}
                  content={job.job}
                  color="blue"
                  onClick={() => act('assign', { assign_target: job.job })}
                  disabled={data.id_rank === job.job}
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Engineering" labelColor="#FFA500">
              {data.engineering_jobs.map((job) => (
                <Button
                  key={job.job}
                  content={job.job}
                  color="orange"
                  onClick={() => act('assign', { assign_target: job.job })}
                  disabled={data.id_rank === job.job}
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Medical" labelColor="#008000">
              {data.medical_jobs.map((job) => (
                <Button
                  key={job.job}
                  content={job.job}
                  color="green"
                  onClick={() => act('assign', { assign_target: job.job })}
                  disabled={data.id_rank === job.job}
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Science" labelColor="#800080">
              {data.science_jobs.map((job) => (
                <Button
                  key={job.job}
                  content={job.job}
                  color="purple"
                  onClick={() => act('assign', { assign_target: job.job })}
                  disabled={data.id_rank === job.job}
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Security" labelColor="#DD0000">
              {data.security_jobs.map((job) => (
                <Button
                  key={job.job}
                  content={job.job}
                  color="red"
                  onClick={() => act('assign', { assign_target: job.job })}
                  disabled={data.id_rank === job.job}
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Cargo" labelColor="#cc6600">
              {data.cargo_jobs.map((job) => (
                <Button
                  key={job.job}
                  content={job.job}
                  color="brown"
                  onClick={() => act('assign', { assign_target: job.job })}
                  disabled={data.id_rank === job.job}
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Service" labelColor="olive">
              {data.service_jobs.map((job) => (
                <Button
                  key={job.job}
                  content={job.job}
                  color="olive"
                  onClick={() => act('assign', { assign_target: job.job })}
                  disabled={data.id_rank === job.job}
                />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Civilian" labelColor="#999999">
              {data.civilian_jobs.map((job) => (
                <Button
                  key={job.job}
                  content={job.job}
                  color="grey"
                  onClick={() => act('assign', { assign_target: job.job })}
                  disabled={data.id_rank === job.job}
                />
              ))}
            </LabeledList.Item>
            {data.centcom_access ? (
              <LabeledList.Item label="Central Command" labelColor="yellow">
                {data.centcom_jobs.map((job) => (
                  <Button
                    key={job.job}
                    content={job.job}
                    color="yellow"
                    onClick={() => act('assign', { assign_target: job.job })}
                    disabled={data.id_rank === job.job}
                  />
                ))}
              </LabeledList.Item>
            ) : (
              ''
            )}
          </LabeledList>
        </Collapsible>
      </Section>
      <Section title="Access Regions">
        <Flex wrap="wrap" justify="space-between" grow={1} align="end">
          {!data.centcom_access &&
            data.regions.map((region) => (
              <Flex.Item key={region.name}>
                <Box fontSize={1.5} bold>
                  {region.name}
                </Box>
                {region.accesses.map((access) => (
                  <Button
                    key={access.ref}
                    content={access.desc}
                    selected={access.allowed}
                    onClick={() =>
                      act('access', {
                        access_target: access.ref,
                        allowed: access.allowed,
                      })
                    }
                  />
                ))}
                <Divider />
              </Flex.Item>
            ))}
          {data.centcom_access && data.all_centcom_access.length ? (
            <Flex.Item>
              {' '}
              <Box fontSize={1.5} bold>
                Central Command
              </Box>
              {data.all_centcom_access.map((access) => (
                <Button
                  key={access.ref}
                  content={access.desc}
                  selected={access.allowed}
                  onClick={() =>
                    act('access', {
                      access_target: access.ref,
                      allowed: access.allowed,
                    })
                  }
                />
              ))}
            </Flex.Item>
          ) : (
            ''
          )}
        </Flex>
      </Section>
    </Section>
  );
};
