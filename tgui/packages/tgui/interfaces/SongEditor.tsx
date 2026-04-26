import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section, Table } from '../components';
import { Window } from '../layouts';

type SongEditorData = {
  lines: string[];
  active_line: number;
  max_lines: number;
  max_line_length: number;
  tick_lag: number;
  show_help: BooleanLike;
  page_num: number;
  page_offset: number;
  total_pages: number;
};

export const SongEditor = (props, context) => {
  const { act, data } = useBackend<SongEditorData>(context);

  return (
    <Window title="Song Editor" width={500} height={560} theme="ntos">
      <Window.Content scrollable>
        <Section
          title={`Lines — Page ${data.page_num} / ${data.total_pages}`}
          buttons={
            <>
              <Button
                icon="plus"
                content="New Line"
                disabled={data.lines.length >= data.max_lines}
                onClick={() => act('newline')}
              />
              <Button
                icon="question-circle"
                selected={!!data.show_help}
                tooltip="Toggle help"
                onClick={() => act('help', { value: data.show_help ? 0 : 1 })}
              />
            </>
          }
        >
          {!!data.show_help && (
            <NoticeBox mb={1}>
              Each line is a sequence of musical notes. Format:{' '}
              <Box as="b">NOTE[octave][duration]</Box> (e.g. C4q = C quarter
              note, octave 4). Tick lag: {data.tick_lag}ms.
            </NoticeBox>
          )}
          {data.lines.length === 0 ? (
            <NoticeBox>No lines. Click "New Line" to add one.</NoticeBox>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>#</Table.Cell>
                <Table.Cell>Content</Table.Cell>
                <Table.Cell />
              </Table.Row>
              {data.lines.map((line, i) => {
                const lineNum = data.page_offset + i + 1;
                const isActive = lineNum === data.active_line;
                return (
                  <Table.Row key={lineNum}>
                    <Table.Cell color={isActive ? 'good' : 'label'}>
                      {lineNum}
                      {isActive && ' ▶'}
                    </Table.Cell>
                    <Table.Cell>
                      <Box
                        style={{
                          fontFamily: 'monospace',
                          wordBreak: 'break-all',
                        }}
                      >
                        {line}
                      </Box>
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        icon="edit"
                        tooltip="Edit"
                        onClick={() => act('modifyline', { value: lineNum })}
                      />
                      <Button
                        icon="trash"
                        color="bad"
                        tooltip="Delete"
                        onClick={() => act('deleteline', { value: lineNum })}
                      />
                    </Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          )}
        </Section>
        <Section>
          <Button
            icon="angle-double-left"
            disabled={data.page_num <= 1}
            onClick={() => act('first_page')}
          />
          <Button
            icon="angle-left"
            disabled={data.page_num <= 1}
            onClick={() => act('prev_page')}
          />
          <Button
            icon="angle-right"
            disabled={data.page_num >= data.total_pages}
            onClick={() => act('next_page')}
          />
          <Button
            icon="angle-double-right"
            disabled={data.page_num >= data.total_pages}
            onClick={() => act('last_page')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
