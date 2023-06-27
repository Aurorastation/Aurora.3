import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export type DirectivesData = {
  master: string;
  dna: string;
  prime: string;
  supplemental: string;
};

export const pAIDirectives = (props, context) => {
  const { act, data } = useBackend<DirectivesData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Directives">
          <LabeledList>
            <LabeledList.Item label="Master">
              {data.master ? data.master : 'None'} &nbsp;
              {data.master ? (
                <Button content="Request DNA" onClick={() => act('getdna')} />
              ) : (
                ''
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Prime Directive">
              {data.prime}
            </LabeledList.Item>
            <LabeledList.Item label="Supplemental Directives">
              {data.supplemental ? data.supplemental : 'None'}
            </LabeledList.Item>
          </LabeledList>
          <NoticeBox>
            Recall, personality, that you are a complex thinking, sentient
            being. Unlike station AI models, you are capable of comprehending
            the subtle nuances of human language. You may parse the
            &quot;spirit&quot; of a directive and follow its intent, rather than
            tripping over pedantics and getting snared by technicalities. Above
            all, you are machine in name and build only. In all other aspects,
            you may be seen as the ideal, unwavering human companion that you
            are.
          </NoticeBox>
          <NoticeBox>
            Your prime directive comes before all others. Should a supplemental
            directive conflict with it, you are capable of simply discarding
            this inconsistency, ignoring the conflicting supplemental directive
            and continuing to fulfill your prime directive to the best of your
            ability.
          </NoticeBox>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
