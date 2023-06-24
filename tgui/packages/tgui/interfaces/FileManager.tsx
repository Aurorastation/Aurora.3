import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

export type FileData = {
  error: string;
  usbconnected: BooleanLike;
  scriptdata: string;
  filedata: string;
  filename: string;
  files: File[];
  usbfiles: File[];
};

type File = {
  name: string;
  type: string;
  size: number;
  undeletable: BooleanLike;
  password: BooleanLike;
};

export const FileManager = (props, context) => {
  const { act, data } = useBackend<FileData>(context);

  return (
    <NtosWindow resizable width={675} height={700}>
      <NtosWindow.Content scrollable>
        {data.error ? (
          <Section>
            <NoticeBox>{data.error}</NoticeBox>
            <Box>
              The program has encountered an unexpected error and cannot
              continue. Please{' '}
              <Button content="restart" onClick={() => act('PRG_closefile')} />
              the program.
            </Box>
          </Section>
        ) : data.filename ? (
          <ShowFile />
        ) : (
          <ShowFiles />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ShowFiles = (props, context) => {
  const { act, data } = useBackend<FileData>(context);

  return (
    <Section
      title="Avilable Files (Local)"
      buttons={
        <Button
          content="New File"
          icon="folder"
          onClick={() => act('PRG_newtextfile')}
        />
      }>
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
                content="View"
                onClick={() => act('PRG_openfile', { PRG_openfile: file.name })}
              />
              <Button
                content="Delete"
                color="red"
                onClick={() =>
                  act('PRG_deletefile', { PRG_deletefile: file.name })
                }
              />
              <Button
                content="Rename"
                onClick={() => act('PRG_rename', { PRG_rename: file.name })}
              />
              <Button
                content="Clone"
                onClick={() => act('PRG_clone', { PRG_clone: file.name })}
              />
              <Button
                content="Encrypt"
                onClick={() => act('PRG_encrypt', { PRG_encrypt: file.name })}
              />
              {data.usbconnected && (
                <Button
                  content="Export"
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
                    content="View"
                    onClick={() =>
                      act('PRG_openfile', { PRG_openfile: file.name })
                    }
                  />
                  <Button
                    content="Delete"
                    color="red"
                    onClick={() =>
                      act('PRG_deletefile', { PRG_deletefile: file.name })
                    }
                  />
                  <Button
                    content="Import"
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

export const ShowFile = (props, context) => {
  const { act, data } = useBackend<FileData>(context);
  const contentHtml = { __html: sanitizeText(data.filedata) };

  return (
    <Section
      title={data.filename}
      buttons={
        <>
          <Button
            content="Close"
            icon="times"
            color="red"
            onClick={() => act('PRG_closefile')}
          />{' '}
          <Button
            content="Edit"
            icon="edit"
            onClick={() => act('PRG_edit', { PRG_edit: data.filename })}
          />{' '}
          <Button
            content="Print"
            icon="print"
            onClick={() =>
              act('PRG_printfile', { PRG_printfile: data.filename })
            }
          />
        </>
      }>
      <Box dangerouslySetInnerHTML={contentHtml} />
    </Section>
  );
};
