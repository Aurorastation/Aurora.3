import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type PollData = {
  server_time: string;
  error: string | null;
  submitting: boolean;
  poll_id: number | null;
};

type PollOption = {
  id: number;
  text: string;
  percentagecalc: boolean;
  minval: number;
  maxval: number;
  descmin: string;
  descmid: string;
  descmax: string;
};

const pollTypes = {
  'Single Option': 'OPTION',
  'Text Reply': 'TEXT',
  Rating: 'NUMVAL',
  'Multiple Choice': 'MULTICHOICE',
};

const newOption = (id: number): PollOption => ({
  id,
  text: '',
  percentagecalc: false,
  minval: 1,
  maxval: 5,
  descmin: '',
  descmid: '',
  descmax: '',
});

export const PollCreator = () => {
  const { act, data } = useBackend<PollData>();
  const [pollType, setPollType] = useState('Single Option');
  const [question, setQuestion] = useState('');
  const [endTime, setEndTime] = useState('');
  const [adminOnly, setAdminOnly] = useState(false);
  const [viewToken, setViewToken] = useState('');
  const [link, setLink] = useState('');
  const [choiceAmount, setChoiceAmount] = useState(1);
  const [options, setOptions] = useState<PollOption[]>([newOption(1)]);
  const [pending, setPending] = useState(false);
  const polltype = pollTypes[pollType];
  const hasOptions = polltype !== 'TEXT';
  const isRating = polltype === 'NUMVAL';
  const busy = data.submitting || (pending && !data.error);
  const valid =
    question.trim().length > 0 &&
    endTime.trim().length > 0 &&
    (!hasOptions ||
      (options.length > 0 &&
        options.every(
          (option) =>
            option.text.trim().length > 0 &&
            (!isRating || option.minval < option.maxval),
        ))) &&
    (polltype !== 'MULTICHOICE' ||
      (Number.isInteger(choiceAmount) &&
        choiceAmount >= 1 &&
        choiceAmount <= options.length));

  const updateOption = (id: number, changes: Partial<PollOption>) => {
    setOptions((current) =>
      current.map((option) =>
        option.id === id ? { ...option, ...changes } : option,
      ),
    );
  };

  return (
    <Window title="Create Poll" theme="admin" width={760} height={800}>
      <Window.Content scrollable>
        {data.poll_id ? (
          <Section title="Poll Created">
            <NoticeBox success>Poll #{data.poll_id} was created.</NoticeBox>
            <Button icon="check" onClick={() => act('cancel')}>
              Close
            </Button>
          </Section>
        ) : (
          <Stack vertical>
            <Stack.Item>
              {data.error && <NoticeBox danger>{data.error}</NoticeBox>}
              <Section title="Poll Settings">
                <LabeledList>
                  <LabeledList.Item label="Type">
                    <Dropdown
                      width={20}
                      options={Object.keys(pollTypes)}
                      selected={pollType}
                      onSelected={setPollType}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Question">
                    <TextArea
                      fluid
                      height={6}
                      value={question}
                      onChange={setQuestion}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="End Time">
                    <Input
                      fluid
                      value={endTime}
                      placeholder="YYYY-MM-DD HH:MM:SS"
                      onChange={setEndTime}
                    />
                    <Box color="label" mt={0.5}>
                      Server time: {data.server_time}
                    </Box>
                  </LabeledList.Item>
                  <LabeledList.Item label="Voters">
                    <Button.Checkbox
                      checked={adminOnly}
                      onClick={() => setAdminOnly(!adminOnly)}
                    >
                      Admins only
                    </Button.Checkbox>
                  </LabeledList.Item>
                  <LabeledList.Item label="Result Key">
                    <Input
                      fluid
                      value={viewToken}
                      placeholder="Optional"
                      onChange={setViewToken}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Information Link">
                    <Input
                      fluid
                      value={link}
                      placeholder="Optional"
                      onChange={setLink}
                    />
                  </LabeledList.Item>
                  {polltype === 'MULTICHOICE' && (
                    <LabeledList.Item label="Allowed Choices">
                      <NumberInput
                        value={choiceAmount}
                        minValue={1}
                        maxValue={Math.max(1, options.length)}
                        step={1}
                        onChange={setChoiceAmount}
                      />
                    </LabeledList.Item>
                  )}
                </LabeledList>
              </Section>
            </Stack.Item>
            {hasOptions && (
              <Stack.Item>
                <Section
                  title={`Answer Options (${options.length})`}
                  buttons={
                    <Button
                      icon="plus"
                      disabled={busy}
                      onClick={() =>
                        setOptions((current) => [
                          ...current,
                          newOption(
                            Math.max(0, ...current.map((option) => option.id)) +
                              1,
                          ),
                        ])
                      }
                    >
                      Add Option
                    </Button>
                  }
                >
                  {options.map((option, index) => (
                    <Box
                      key={option.id}
                      mt={index ? 2 : 0}
                      pt={index ? 1 : 0}
                      style={index ? { borderTop: '1px solid #555' } : undefined}
                    >
                      <Stack align="center" mb={0.5}>
                        <Stack.Item grow bold>
                          Option {index + 1}
                        </Stack.Item>
                        <Stack.Item>
                          <Button.Checkbox
                            checked={option.percentagecalc}
                            onClick={() =>
                              updateOption(option.id, {
                                percentagecalc: !option.percentagecalc,
                              })
                            }
                          >
                            Calculate percentage
                          </Button.Checkbox>
                        </Stack.Item>
                        <Stack.Item>
                          <Button
                            icon="trash"
                            color="bad"
                            tooltip="Remove option"
                            disabled={busy}
                            onClick={() =>
                              setOptions((current) =>
                                current.filter(
                                  (entry) => entry.id !== option.id,
                                ),
                              )
                            }
                          />
                        </Stack.Item>
                      </Stack>
                      <TextArea
                        fluid
                        height={4}
                        value={option.text}
                        onChange={(text) => updateOption(option.id, { text })}
                      />
                      {isRating && (
                        <Box mt={1}>
                          <LabeledList>
                            <LabeledList.Item label="Rating Range">
                              <NumberInput
                                value={option.minval}
                                step={1}
                                onChange={(minval) =>
                                  updateOption(option.id, { minval })
                                }
                              />
                              <Box inline mx={1}>
                                to
                              </Box>
                              <NumberInput
                                value={option.maxval}
                                step={1}
                                onChange={(maxval) =>
                                  updateOption(option.id, { maxval })
                                }
                              />
                            </LabeledList.Item>
                            {(
                              [
                                ['descmin', 'Minimum Label'],
                                ['descmid', 'Median Label'],
                                ['descmax', 'Maximum Label'],
                              ] as const
                            ).map(([field, label]) => (
                              <LabeledList.Item key={field} label={label}>
                                <TextArea
                                  fluid
                                  height={3}
                                  value={option[field]}
                                  placeholder="Optional"
                                  onChange={(value) =>
                                    updateOption(option.id, { [field]: value })
                                  }
                                />
                              </LabeledList.Item>
                            ))}
                          </LabeledList>
                        </Box>
                      )}
                    </Box>
                  ))}
                </Section>
              </Stack.Item>
            )}
            <Stack.Item>
              <Stack justify="space-between">
                <Stack.Item>
                  <Button icon="times" onClick={() => act('cancel')}>
                    Cancel
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="check"
                    color="good"
                    disabled={!valid || busy}
                    onClick={() => {
                      setPending(true);
                      act('submit', {
                        polltype,
                        question,
                        endtime: endTime,
                        adminonly: adminOnly,
                        viewtoken: viewToken,
                        link,
                        choice_amount: choiceAmount,
                        options: hasOptions ? options : [],
                      });
                    }}
                  >
                    Create Poll
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};
