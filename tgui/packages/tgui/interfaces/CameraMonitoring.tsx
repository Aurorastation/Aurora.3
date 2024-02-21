import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Input, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export type CameraData = {
  current_camera: Camera;
  current_network: string;
  networks: Network[];
  cameras: Camera[];
};

type Camera = {
  name: string;
  deact: BooleanLike; // deactivated
  camera: string; // ref
  x: number;
  y: number;
  z: number;
};

type Network = {
  tag: string;
  has_access: BooleanLike;
};

export const CameraMonitoring = (props, context) => {
  const { act, data } = useBackend<CameraData>(context);

  return (
    <NtosWindow resizable height={800} width={900}>
      <NtosWindow.Content scrollable>
        {data.networks && data.networks.length ? (
          <ShowNetworks />
        ) : (
          <NoticeBox>No networks available.</NoticeBox>
        )}
        {data.current_network ? <ShowNetworkCameras /> : ''}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ShowNetworks = (props, context) => {
  const { act, data } = useBackend<CameraData>(context);

  return (
    <Section
      title="Networks"
      buttons={
        <Button
          content="Reset"
          icon="user-circle"
          onClick={() => act('reset')}
        />
      }>
      {data.networks
        .filter((n) => n.has_access)
        .map((network) => (
          <Button
            content={network.tag}
            selected={data.current_network === network.tag}
            key={network.tag}
            onClick={() =>
              act('switch_network', { switch_network: network.tag })
            }
          />
        ))}
    </Section>
  );
};

export const ShowNetworkCameras = (props, context) => {
  const { act, data } = useBackend<CameraData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <Section
      title="Cameras"
      buttons={
        <Input
          autoFocus
          autoSelect
          placeholder="Search by name"
          width="40vw"
          maxLength={512}
          onInput={(e, value) => {
            setSearchTerm(value);
          }}
          value={searchTerm}
        />
      }>
      {data.cameras && data.cameras.length ? (
        data.cameras
          .filter(
            (c) => c.name?.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1
          )
          .map((camera) => (
            <Button
              content={camera.name}
              key={camera.camera}
              disabled={camera.deact}
              selected={
                data.current_camera &&
                data.current_camera.camera === camera.camera
              } // thanks whoever named this nanoui bit this and then shat it around everywhere
              onClick={() =>
                act('switch_camera', { switch_camera: camera.camera })
              }
            />
          ))
      ) : (
        <NoticeBox>No cameras detected.</NoticeBox>
      )}
    </Section>
  );
};
