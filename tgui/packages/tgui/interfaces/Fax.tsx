import { useBackend } from '../backend';
import { BooleanLike } from '../../common/react';
import { round } from '../../common/math';
import { capitalizeAll } from '../../common/string';
import { Section, Box, Button, BlockQuote, Dropdown, LabeledList } from '../components';
import { Window } from '../layouts';

type PDA = {
  name: string;
  ref: string;
};

type FaxData = {
  destination: string;
  bossname: string;
  auth: BooleanLike;
  cooldown_end: number;
  idname: string;
  paper: string;
  world_time: number;
  alertpdas: PDA[];
  department: String;
  departments: String[];
};

export const Fax = (props, context) => {
  const { act, data } = useBackend<FaxData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Confirm Identity">
          <Button
            content={data.idname ? data.idname : '-------'}
            icon="eject"
            onClick={(value) => act('remove_id')}
          />
        </Section>
        {data.auth ? (
          <FaxWindow />
        ) : (
          <Section title="No identification provided." />
        )}
        <Section title="PDAs to Notify">
          {data.alertpdas.length ? (
            <PDANotifyWindow />
          ) : (
            <Box>No PDAs linked.</Box>
          )}
          <Button
            icon="plus"
            content="Link PDA"
            onClick={(value) => act('linkpda')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

const FaxWindow = (props, context) => {
  const { act, data } = useBackend<FaxData>(context);
  const remaining_cooldown = data.cooldown_end - data.world_time;

  return (
    <Section title="Fax Options">
      <LabeledList>
        <LabeledList.Item label="Logged Into">
          {data.bossname} Bluespace Communication System{' '}
        </LabeledList.Item>
      </LabeledList>
      {remaining_cooldown <= 0 ? (
        <SendWindow />
      ) : (
        <Box>
          Transmitter arrays re-aligning. Please stand by.{' '}
          <Box>
            <b>{round(remaining_cooldown / 10, 0)}</b> seconds remaining.
          </Box>
        </Box>
      )}
    </Section>
  );
};

const SendWindow = (props, context) => {
  const { act, data } = useBackend<FaxData>(context);

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Sending To">
          <Dropdown
            options={data.departments}
            onSelected={(value) =>
              act('select_destination', { select_destination: value })
            }
            width="100%"
            displayText={data.destination}
          />
        </LabeledList.Item>
      </LabeledList>
      {data.paper ? (
        <PaperWindow />
      ) : (
        <Box>Please insert the document to send.</Box>
      )}
    </Section>
  );
};

const PaperWindow = (props, context) => {
  const { act, data } = useBackend<FaxData>(context);

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Currently Sending">
          {capitalizeAll(data.paper)}
        </LabeledList.Item>
      </LabeledList>
      <Button icon="copy" content="Send" onClick={(value) => act('send')} />
      <Button icon="stop" content="Remove" onClick={(value) => act('remove')} />
    </Section>
  );
};

const PDANotifyWindow = (props, context) => {
  const { act, data } = useBackend<FaxData>(context);

  return (
    <Section>
      {data.alertpdas.map((PDA) => (
        <Section key="PDA">
          <BlockQuote>
            {PDA.name}{' '}
            <Button
              icon="minus"
              content="Unlink"
              onClick={(value) => act('unlink', { unlink: PDA.ref })}
            />
          </BlockQuote>
        </Section>
      ))}
    </Section>
  );
};
