import { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Input, Section } from 'tgui-core/components';
import { Window } from '../layouts';

export type CardData = {
  name: string;
  age: number;
  sex: string;
  blood_type: string;
  dna_hash: string;
  fingerprint_hash: string;
  employer_faction: string;
  assignment: string;
  citizenship: string;
  electronic_warfare: BooleanLike;
};

export const AgentID = (props) => {
  const { act, data } = useBackend<CardData>();
  const {
    name,
    age,
    sex,
    blood_type,
    dna_hash,
    fingerprint_hash,
    employer_faction,
    assignment,
    citizenship,
    electronic_warfare,
  } = data;

  return (
    <Window width={500} height={600} theme="malfunction">
      <Window.Content>
        <Section title="User Information">
          <LabeledList>
            <LabeledList.Item label="Name">
              <Input
                value={data.name}
                placeholder="Input the desired value, then press enter."
                width="100%"
                onChange={(value) => act('setName', { name: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Age">
              <NumberInput
                value={data.age}
                maxValue={1000}
                minValue={1}
                step={1}
                color="white"
                unit="years"
                onChange={(value) => act('setAge', { age: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Sex">
              <Input
                value={data.sex}
                placeholder="Input the desired value, then press enter."
                width="100%"
                onChange={(value) => act('setSex', { sex: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Photo">
              <Button
                content="Update Photo"
                onClick={() => act('updatePhoto')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Biometric Data">
          <LabeledList>
            <LabeledList.Item label="Blood Type">
              <Input
                value={data.blood_type}
                placeholder="Input the desired value, then press enter."
                width="20%"
                onChange={(value) =>
                  act('setBloodType', { bloodtype: value })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="DNA Hash">
              <Input
                value={data.dna_hash}
                placeholder="Input the desired value, then press enter."
                width="100%"
                onChange={(value) => act('setDNAHash', { dnahash: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Fingerprint Hash">
              <Input
                value={data.fingerprint_hash}
                placeholder="Input the desired value, then press enter."
                width="100%"
                onChange={(value) =>
                  act('setFingerprintHash', { fingerprinthash: value })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Affiliation Details">
          <LabeledList>
            <LabeledList.Item label="Faction/Employer">
              <Input
                value={data.employer_faction}
                placeholder="Input the desired value, then press enter."
                width="100%"
                onChange={(value) => act('setEmployer', { employer: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Assignment">
              <Input
                value={data.assignment}
                placeholder="Input the desired value, then press enter."
                width="100%"
                onChange={(value) =>
                  act('setAssignment', { assignment: value })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Citizenship">
              <Input
                value={data.citizenship}
                placeholder="Input the desired value, then press enter."
                width="100%"
                onChange={(value) =>
                  act('setCitizenship', { citizenship: value })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Card Management">
          <LabeledList>
            <LabeledList.Item label="Card Appearance">
              <Button
                content="Set Card Appearance"
                onClick={() => act('setCardAppearance')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Electronic Warfare Suite">
              <Button
                content="Enable"
                color="good"
                disabled={data.electronic_warfare}
                onClick={() => act('enableElectronicWarfare')}
              />
              <Button
                content="Disable"
                color="bad"
                disabled={!data.electronic_warfare}
                onClick={() => act('disableElectronicWarfare')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Factory Reset">
              <Button.Confirm
                content="Reset ALL Card Data"
                confirmContent="This will also erase all access! Confirm?"
                color="bad"
                icon="exclamation-circle"
                onClick={() => act('factoryReset')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
