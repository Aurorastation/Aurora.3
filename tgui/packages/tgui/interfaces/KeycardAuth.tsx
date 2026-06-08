import { BlockQuote, Button, LabeledList, Section } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type KeycardAuthData = {
  screen: number;
  event: string;
  busy: boolean;
  can_broadcast_distress: boolean;
};

export const KeycardAuth = () => {
  const { act, data } = useBackend<KeycardAuthData>();

  return (
    <Window theme="scc">
      <Window.Content scrollable>
        <Section title="Keycard Authentication Device">
          <BlockQuote>
            This device requires the simultaneous swipe of two Command level ID cards to trigger high security events.
          </BlockQuote>

          {data.busy ? (
            <BlockQuote>
              Waiting for the other device to confirm the request.
            </BlockQuote>
          ) : data.screen === 1 ? (
            <LabeledList>
              <LabeledList.Item label="Red Alert">
                <Button
                  color="bad"
                  onClick={() => act('select_event', { event: 'Red alert' })}
                >
                  Select
                </Button>
              </LabeledList.Item>

              {data.can_broadcast_distress && (
                <LabeledList.Item label="Broadcast Distress Beacon">
                  <Button
                    color="bad"
                    onClick={() =>
                      act('select_event', { event: 'Distress Beacon' })
                    }
                  >
                    Select
                  </Button>
                </LabeledList.Item>
              )}

              <LabeledList.Item label="Emergency Evacuation">
                <Button
                  color="bad"
                  onClick={() =>
                    act('select_event', { event: 'Emergency Evacuation' })
                  }
                >
                  Select
                </Button>
              </LabeledList.Item>
            </LabeledList>
          ) : (
            <Section title="Swipe to Authorize">
              <BlockQuote>
                Please swipe your card to authorize the following event:
                <br />
                <b>{data.event || 'Unknown event'}</b>
              </BlockQuote>

              <div>
                <Button color="secondary" onClick={() => act('reset')}>
                  Back
                </Button>
              </div>
            </Section>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
