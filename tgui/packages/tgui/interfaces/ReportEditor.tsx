import {
  Box,
  Button,
  Input,
  LabeledList,
  Section,
  Stack,
  Table,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

type ReportSummary = {
  uid: number;
  name: string;
  form: string;
  department: string;
  size: number;
  usb: BooleanLike;
};

type FormSummary = {
  id: number;
  name: string;
  department: string;
};

type FieldSignature = {
  id: number;
  name: string;
  assignment: string;
  signature: string;
  signed_at: string;
  can_remove: BooleanLike;
};

type ReportEditorData = {
  screen: number;
  message: string;
  form_filter: string;
  usb_connected: BooleanLike;
  forms: FormSummary[];
  reports: ReportSummary[];
  usb_reports: ReportSummary[];
  report_name: string;
  form_name: string;
  form_id: number;
  form_department: string;
  created_by: string;
  created_at: string;
  modified_at: string;
  field_count: number;
  filled_fields: number;
  read_only: BooleanLike;
  selected_field: number;
  selected_value: string;
  selected_signatures: FieldSignature[];
  preview: string;
};

export const ReportEditor = (props) => {
  const { data } = useBackend<ReportEditorData>();

  return (
    <NtosWindow width={900} height={700} resizable>
      <NtosWindow.Content
        className="ReportEditor"
        scrollable={data.screen !== 3}
      >
        {data.screen === 3 ? (
          <Stack vertical fill>
            {!!data.message && (
              <Stack.Item>
                <Box className="ReportEditor__notice">{data.message}</Box>
              </Stack.Item>
            )}
            <Stack.Item grow>
              <ReportDocument />
            </Stack.Item>
          </Stack>
        ) : (
          <>
            {!!data.message && (
              <Box color="yellow" mb={1}>
                {data.message}
              </Box>
            )}
            {data.screen === 1 ? <ReportList /> : <FormList />}
          </>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const ReportList = (props) => {
  const { act, data } = useBackend<ReportEditorData>();
  const reports = [...(data.reports || []), ...(data.usb_reports || [])];

  return (
    <Section
      title="Structured Reports"
      buttons={
        <Button
          icon="plus"
          content="New from Form"
          onClick={() => act('show_forms')}
        />
      }
    >
      {!reports.length ? (
        <Box color="label">No RPT files are available on connected drives.</Box>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Form</Table.Cell>
            <Table.Cell>Department</Table.Cell>
            <Table.Cell>Drive</Table.Cell>
            <Table.Cell collapsing />
          </Table.Row>
          {reports.map((report) => (
            <Table.Row key={report.uid}>
              <Table.Cell>{report.name}.RPT</Table.Cell>
              <Table.Cell>{report.form}</Table.Cell>
              <Table.Cell>{report.department || 'General'}</Table.Cell>
              <Table.Cell>{report.usb ? 'USB' : 'Internal'}</Table.Cell>
              <Table.Cell collapsing>
                <Button
                  icon="folder-open"
                  content="Open"
                  onClick={() =>
                    act('open_report', { uid: report.uid, usb: report.usb })
                  }
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};

const FormList = (props) => {
  const { act, data } = useBackend<ReportEditorData>();

  return (
    <Section
      title="Database Forms"
      buttons={
        <>
          <Button icon="arrow-left" content="Reports" onClick={() => act('show_files')} />
          <Button icon="times" content="Clear Filter" onClick={() => act('clear_filter')} />
        </>
      }
    >
      <Input
        fluid
        mb={1}
        value={data.form_filter}
        placeholder="Filter by form name or department"
        onChange={(value) => act('set_filter', { filter: value })}
      />
      <Table>
        <Table.Row header>
          <Table.Cell>ID</Table.Cell>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Department</Table.Cell>
          <Table.Cell collapsing />
        </Table.Row>
        {(data.forms || []).map((form) => (
          <Table.Row key={form.id}>
            <Table.Cell>SCCF-{form.id}</Table.Cell>
            <Table.Cell>{form.name}</Table.Cell>
            <Table.Cell>{form.department}</Table.Cell>
            <Table.Cell collapsing>
              <Button
                icon="plus"
                content="Create"
                onClick={() => act('create_report', { id: form.id })}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const ReportDocument = (props) => {
  const { act, data } = useBackend<ReportEditorData>();
  const preview = { __html: sanitizeText(data.preview || '') };

  const selectField = (index: number) => {
    if (index >= 1 && index <= data.field_count) {
      act('select_field', { index });
    }
  };

  const selectClickedField = (event) => {
    const target = event.target as HTMLElement;
    const field = target.closest<HTMLElement>('[data-report-field]');
    if (field?.dataset.reportField) {
      act('select_field', { index: Number(field.dataset.reportField) });
    }
  };

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Box className="ReportEditor__header">
          <Stack align="center">
            <Stack.Item grow>
              <Box className="ReportEditor__eyebrow">
                SCCF-{data.form_id} · {data.form_department || 'General'}
              </Box>
              <Box className="ReportEditor__title">{data.form_name}</Box>
              <Box className="ReportEditor__filename">{data.report_name}.RPT</Box>
            </Stack.Item>
            <Stack.Item>
              <Box className="ReportEditor__progress">
                <Box className="ReportEditor__progressValue">
                  {data.filled_fields}/{data.field_count}
                </Box>
                <Box className="ReportEditor__progressLabel">fields completed</Box>
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button icon="arrow-left" content="Reports" onClick={() => act('show_files')} />
              <Button icon="print" content="Print" onClick={() => act('print_report')} />
              <Button icon="file-export" content="Export" onClick={() => act('export_text')} />
            </Stack.Item>
          </Stack>
        </Box>
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item grow basis="72%">
            <Section fill scrollable className="ReportEditor__workspace">
              {/** biome-ignore lint/a11y/useKeyWithClickEvents: Individual report fields are keyboard-editable in the side panel. */}
              {/** biome-ignore lint/security/noDangerouslySetInnerHtml: Form HTML is purified before display. */}
              <Box
                className="ReportEditor__preview"
                onClick={selectClickedField}
                dangerouslySetInnerHTML={preview}
              />
            </Section>
          </Stack.Item>
          <Stack.Item basis="28%">
            <Box className="ReportEditor__sidebar">
              <Section
                title={data.selected_field ? `Field ${data.selected_field} of ${data.field_count}` : 'Fields'}
                buttons={
                  data.selected_field ? (
                    <>
                      <Button
                        icon="chevron-left"
                        tooltip="Previous field"
                        disabled={data.selected_field <= 1}
                        onClick={() => selectField(data.selected_field - 1)}
                      />
                      <Button
                        icon="chevron-right"
                        tooltip="Next field"
                        disabled={data.selected_field >= data.field_count}
                        onClick={() => selectField(data.selected_field + 1)}
                      />
                    </>
                  ) : undefined
                }
              >
                {data.selected_field ? (
                  <>
                    <Box color="label" mb={1}>
                      All fields are optional. Select any highlighted field in the form.
                    </Box>
                    <TextArea
                      fluid
                      height="12rem"
                      disabled={!!data.read_only}
                      value={data.selected_value || ''}
                      onChange={(value) => act('set_field', { value })}
                    />
                    <Button
                      mt={1}
                      icon="pen"
                      color="good"
                      content="Sign Field"
                      disabled={!!data.read_only}
                      onClick={() => act('sign_field')}
                    />
                    <Button
                      mt={1}
                      icon="eraser"
                      content="Clear Field"
                      disabled={!!data.read_only}
                      onClick={() => act('set_field', { value: '' })}
                    />
                    {!!data.selected_signatures?.length && (
                      <Box mt={1.25}>
                        <Box className="ReportEditor__signatureHeading">
                          Verified signatures
                        </Box>
                        {data.selected_signatures.map((signature) => {
                          const signatureHtml = {
                            __html: sanitizeText(signature.signature),
                          };
                          return (
                            <Box className="ReportEditor__signature" key={signature.id}>
                              <Box className="ReportEditor__signatureMark">✓</Box>
                              <Box className="ReportEditor__signatureBody">
                                {/** biome-ignore lint/security/noDangerouslySetInnerHtml: Character signature HTML is purified before display. */}
                                <Box
                                  className="ReportEditor__signatureText"
                                  dangerouslySetInnerHTML={signatureHtml}
                                />
                                <Box>{signature.name}</Box>
                                <Box color="label">{signature.assignment}</Box>
                                <Box color="label">{signature.signed_at}</Box>
                              </Box>
                              {signature.can_remove && (
                                <Button
                                  icon="times"
                                  color="bad"
                                  tooltip="Remove your signature"
                                  onClick={() => act('remove_signature', { id: signature.id })}
                                />
                              )}
                            </Box>
                          );
                        })}
                      </Box>
                    )}
                  </>
                ) : (
                  <Box color="label">This form has no editable fields.</Box>
                )}
              </Section>
              <Section title="Document" mt={1}>
                <LabeledList>
                  <LabeledList.Item label="Created by">{data.created_by}</LabeledList.Item>
                  <LabeledList.Item label="Created">{data.created_at}</LabeledList.Item>
                  <LabeledList.Item label="Modified">{data.modified_at}</LabeledList.Item>
                </LabeledList>
                <Input
                  fluid
                  mt={1}
                  disabled={!!data.read_only}
                  value={data.report_name}
                  onChange={(value) => act('rename_report', { name: value })}
                />
                {!!data.read_only && (
                  <Box color="average" mt={1}>
                    This report is on a read-only drive.
                  </Box>
                )}
              </Section>
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
