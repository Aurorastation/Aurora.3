import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, NoticeBox, ProgressBar, Section } from '../components';
import { NtosWindow } from '../layouts';

export type DoorjackData = {
  extended: BooleanLike;
  connected: BooleanLike;
  ishacking: BooleanLike;
  progress: number;
  aborted: BooleanLike;
};

export const pAIDoorjack = (props, context) => {
  const { act, data } = useBackend<DoorjackData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Doorjack">
          <NoticeBox>
            Cable{' '}
            {data.connected ? (
              'connected'
            ) : data.extended ? (
              'extended'
            ) : (
              <Button content="retracted" onClick={() => act('extend')} />
            )}
            .
          </NoticeBox>
          {data.connected ? (
            <Section title="Hacking">
              {data.ishacking ? (
                <>
                  <ProgressBar
                    value={data.progress}
                    maxValue={1000}
                    minValue={0}>
                    {data.progress / 10}%
                  </ProgressBar>{' '}
                  <Button content="Cancel" onClick={() => act('cancel')} />
                </>
              ) : (
                <Button content="Start" onClick={() => act('hack')} />
              )}
            </Section>
          ) : data.aborted ? (
            'Hack aborted!'
          ) : (
            ''
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
