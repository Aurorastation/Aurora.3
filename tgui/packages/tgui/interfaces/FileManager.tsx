import {
  Box,
  Button,
  TextArea,
  Input,
  NoticeBox,
  Section,
  Table,
  Divider,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useSharedState } from '../backend';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

// Screen constants (must match DM defines)
const FMS_FILEBROWSER = 0;
const FMS_SHOWFILE = 1;
const FMS_FORMS = 2;
const FMS_NEWFILE = 3;
const FMS_FOLDER = 4;
const FMS_EDIT = 5;

const MAX_TEXTFILE_LENGTH = 128000;

export type FileData = {
  error: string;
  sql_error?: BooleanLike;
  usbconnected: BooleanLike;
  scriptdata: string;
  filedata: string;
  file_is_usb: BooleanLike;
  filename: string;
  files: File[];
  forms?: FormEntry[];
  usbfiles: File[];
  screen: number;
};

type File = {
  name: string;
  type: string;
  size: number;
  undeletable: BooleanLike;
  password: BooleanLike;
};

type FormEntry = {
  id: string;
  name: string;
  department: string;
};

export const FileManager = (props) => {
  const { act, data } = useBackend<FileData>();

  return (
    <NtosWindow resizable
          title={`File_Manager`}
          width={670}
          height={700}
        >
          <NtosWindow.Content scrollable>
            {data.screen === FMS_FILEBROWSER && <FileBrowser act={act} data={data} />}
            {data.screen === FMS_FORMS && <FormBrowser act={act} data={data} />}
            {data.screen === FMS_SHOWFILE && <ShowFile act={act} data={data} />}
            {data.screen === FMS_NEWFILE && <NewFile act={act} data={data} />}
            {data.screen === FMS_EDIT && <File_Edit act={act} data={data} />}
          </NtosWindow.Content>
        </NtosWindow>
  );
};

export const FileBrowser = (props) => {
  const { act, data } = useBackend<FileData>();

  return (
    <Section
      title="Avilable Files (Local)"
    >
      <Button
          children="New File"
          icon="folder"
          onClick={() => act('set_screen', { screen: FMS_NEWFILE })}
        />
        <Button
          children="New Form"
          icon="folder"
          onClick={() => act('set_screen', { screen: FMS_FORMS })}
        />
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Type</Table.Cell>
          <Table.Cell>Size</Table.Cell>
          <Table.Cell>Operations</Table.Cell>
        </Table.Row>
        {data.files.map((file) => (
          <Table.Row key={file.name}>
            <Table.Cell>{file.name}</Table.Cell>
            <Table.Cell>{file.type}</Table.Cell>
            <Table.Cell>{file.size} GQ</Table.Cell>
            <Table.Cell>
              <Button
                children="View"
                onClick={() => act('PRG_openfile', { PRG_openfile: file.name })}
              />
              <Button
                children="Delete"
                color="red"
                onClick={() =>
                  act('PRG_deletefile', { PRG_deletefile: file.name })
                }
              />
              <Button
                children="Rename"
                onClick={() => act('PRG_rename', { PRG_rename: file.name })}
              />
              <Button
                children="Clone"
                disabled={file.type === 'PRG'}
                onClick={() => act('PRG_clone', { PRG_clone: file.name })}
              />
              <Button
                children="Encrypt"
                onClick={() => act('PRG_encrypt', { PRG_encrypt: file.name })}
              />
              {data.usbconnected && (
                <Button
                  children="Export"
                  onClick={() =>
                    act('PRG_copytousb', { PRG_copytousb: file.name })
                  }
                />
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
      {data.usbconnected && data.usbfiles.length && (
        <Section title="USB Files">
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Type</Table.Cell>
              <Table.Cell>Size</Table.Cell>
              <Table.Cell>Operations</Table.Cell>
            </Table.Row>
            {data.usbfiles.map((file) => (
              <Table.Row key={file.name}>
                <Table.Cell>{file.name}</Table.Cell>
                <Table.Cell>{file.type}</Table.Cell>
                <Table.Cell>{file.size} GQ</Table.Cell>
                <Table.Cell>
                  <Button
                    children="View"
                    onClick={() =>
                      act('PRG_usbopenfile', { PRG_usbopenfile: file.name })
                    }
                  />
                  <Button
                    children="Delete"
                    color="red"
                    onClick={() =>
                      act('PRG_usbdeletefile', { PRG_usbdeletefile: file.name })
                    }
                  />
                  <Button
                    children="Import"
                    onClick={() =>
                      act('PRG_copyfromusb', { PRG_copyfromusb: file.name })
                    }
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      )}
    </Section>
  );
};

export const ShowFile = (props) => {
  const { act, data } = useBackend<FileData>();
  const contentHtml = { __html: sanitizeText(data.filedata) };

  return (
    <Section
      title={data.filename}
      buttons={
        <>
          <Button
            children="Close"
            icon="times"
            color="red"
            onClick={() => act('PRG_closefile')}
          />{' '}
          <Button
            children="Edit"
            icon="edit"
            disabled={data.file_is_usb}
            onClick={() => act('set_screen', { screen: FMS_EDIT })}
          />{' '}
          <Button
            children="Print"
            icon="print"
            disabled={data.file_is_usb}
            onClick={() =>
              act('PRG_printfile', { PRG_printfile: data.filename })
            }
          />
        </>
      }
    >
      {/** biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify. */}
      <Box dangerouslySetInnerHTML={contentHtml} />
    </Section>
  );
};

export const FormBrowser = (props) => {
  const { act, data } = useBackend<FileData>();

return (
  <Section
    title="Forms Database"
    buttons={
      <Button
        icon="arrow-left"
        children="Back"
        onClick={() => act('set_screen', { screen: FMS_FILEBROWSER })}
      />
    }
  >
    {data.sql_error ? (
      <NoticeBox danger>
        Database connection failed or no forms found.
      </NoticeBox>
    ) : !data.forms ? (
      <NoticeBox>Loading...</NoticeBox>
    ) : (
      <>
        <Box mb={1}>
          <Button
            icon="sync"
            children="Show All"
            onClick={() => act('reset_sql')}
          />
        </Box>
        <Table>
          <Table.Row header>
            <Table.Cell>ID</Table.Cell>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Department</Table.Cell>
            <Table.Cell />
          </Table.Row>
          {data.forms.map((form) => (
            <Table.Row key={form.id}>
              <Table.Cell>SCCF-{form.id}</Table.Cell>
              <Table.Cell>{form.name}</Table.Cell>
              <Table.Cell>
                <Button
                  children={form.department}
                  onClick={() =>
                    act('sort_forms', { department: form.department })
                  }
                />
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  icon="info-circle"
                  tooltip="What is this?"
                  onClick={() => act('whatis', { id: form.id })}
                />
                <Button
                  icon="print"
                  tooltip="Generate Form"
                  onClick={() => act('PRG_generate_form', { id: form.id })}
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </>
    )}
  </Section>
  );
};

export const File_Edit = (props) => {
  const { act, data } = useBackend<FileData>();

  return (
    <Section
      title={`File - ${data.filename}`} >
        <Button
          icon="arrow-left"
          children="Back"
          onClick={() => act('set_screen', { screen: FMS_FILEBROWSER })}
          />
        <Button
          icon="eye"
          tooltip="Preview"
          onClick={() => act('set_screen', { screen: FMS_SHOWFILE })}
        />
        <TextArea
          fluid
          spellcheck
          value={data.filedata}
          placeholder="Type something here..."
          onEnter={(e) => act('PRG_edit', { PRG_edit: e.valueOf() })}
        />
      </Section>
  );
};

export const NewFile = (props) => {
  const { act, data } = useBackend<FileData>();
  let name = 'NewFile';
  let filedata = '';

  return (
    <Section
      title="New File"
      >
      <Button
        icon="arrow-left"
        children="Back"
        onClick={() => act('set_screen', { screen: FMS_FILEBROWSER })}
      />
      <Input
        placeholder="Enter file name..."
        onChange={(filename) => name = filename.valueOf() }
      />
      <TextArea
        fluid
        spellcheck
        placeholder="Type something here..."
        onChange={(text) => filedata = text.valueOf() }
      />
      <Button
        children="Create"
        onClick={() => act('PRG_newtextfile', { PRG_newfilename: name, PRG_newfiletext: filedata })}
      />
      </Section>
  );
};
