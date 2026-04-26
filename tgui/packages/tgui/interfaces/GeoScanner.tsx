import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

type GeoScannerData = {
  scanned_item: string;
  scanned_item_desc: string;
  last_scan_data: string;
  scan_progress: number;
  scanning: BooleanLike;
  scanner_seal_integrity: number;
  scanner_rpm: number;
  scanner_temperature: number;
  coolant_usage_rate: number;
  unused_coolant_abs: number;
  unused_coolant_per: number;
  coolant_purity: number;
  optimal_wavelength: number;
  maser_wavelength: number;
  maser_efficiency: number;
  radiation: number;
  t_left_radspike: number;
  rad_shield_on: BooleanLike;
};

export const GeoScanner = (props, context) => {
  const { act, data } = useBackend<GeoScannerData>(context);

  return (
    <Window
      title="High Res Radiocarbon Spectrometer"
      width={700}
      height={620}
      theme="ntos"
    >
      <Window.Content scrollable>
        <Section title="Sample">
          {data.scanned_item ? (
            <LabeledList>
              <LabeledList.Item label="Item">
                {data.scanned_item}
              </LabeledList.Item>
              <LabeledList.Item label="Description">
                {data.scanned_item_desc}
              </LabeledList.Item>
            </LabeledList>
          ) : (
            <NoticeBox>No item loaded. Insert an item to scan.</NoticeBox>
          )}
          <Box mt={1}>
            <Button
              icon={data.scanning ? 'stop' : 'play'}
              content={data.scanning ? 'Stop Scan' : 'Start Scan'}
              color={data.scanning ? 'bad' : 'good'}
              disabled={!data.scanned_item && !data.scanning}
              onClick={() => act('scan_item')}
            />
            <Button
              icon="eject"
              content="Eject Item"
              disabled={!data.scanned_item || !!data.scanning}
              onClick={() => act('eject_item')}
            />
          </Box>
        </Section>

        <Section title="Scan Progress">
          <ProgressBar
            value={data.scan_progress}
            minValue={0}
            maxValue={100}
            color={data.scanning ? 'good' : 'average'}
          >
            {data.scan_progress}%
          </ProgressBar>
        </Section>

        <Section title="Machine Status">
          <LabeledList>
            <LabeledList.Item label="Seal Integrity">
              <ProgressBar
                value={data.scanner_seal_integrity}
                minValue={0}
                maxValue={100}
                color={
                  data.scanner_seal_integrity > 50
                    ? 'good'
                    : data.scanner_seal_integrity > 20
                      ? 'average'
                      : 'bad'
                }
              >
                {data.scanner_seal_integrity}%
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="RPM">
              {data.scanner_rpm} RPM
            </LabeledList.Item>
            <LabeledList.Item label="Temperature">
              <Box
                color={
                  data.scanner_temperature > 800
                    ? 'bad'
                    : data.scanner_temperature > 400
                      ? 'average'
                      : 'good'
                }
              >
                {data.scanner_temperature} K
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Coolant">
          <LabeledList>
            <LabeledList.Item label="Usage Rate">
              <Button
                content={`${data.coolant_usage_rate} u/s`}
                onClick={() => act('coolant_rate', { delta: 1 })}
              />
              <Button
                icon="minus"
                onClick={() => act('coolant_rate', { delta: -1 })}
              />
              <Button
                icon="plus"
                onClick={() => act('coolant_rate', { delta: 1 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Coolant Remaining">
              <ProgressBar
                value={data.unused_coolant_per}
                minValue={0}
                maxValue={100}
                color={
                  data.unused_coolant_per > 50
                    ? 'good'
                    : data.unused_coolant_per > 20
                      ? 'average'
                      : 'bad'
                }
              >
                {data.unused_coolant_abs}u ({data.unused_coolant_per}%)
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Purity">
              {data.coolant_purity}%
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Maser">
          <LabeledList>
            <LabeledList.Item label="Wavelength">
              <Button
                icon="minus"
                onClick={() => act('maser_wavelength', { delta: -1 })}
              />
              <Box display="inline-block" mx={1}>
                {data.maser_wavelength} nm
              </Box>
              <Button
                icon="plus"
                onClick={() => act('maser_wavelength', { delta: 1 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Optimal Wavelength">
              {data.optimal_wavelength} nm
            </LabeledList.Item>
            <LabeledList.Item label="Efficiency">
              <ProgressBar
                value={data.maser_efficiency}
                minValue={0}
                maxValue={100}
                color={
                  data.maser_efficiency > 70
                    ? 'good'
                    : data.maser_efficiency > 30
                      ? 'average'
                      : 'bad'
                }
              >
                {data.maser_efficiency}%
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Radiation">
          <LabeledList>
            <LabeledList.Item label="Current Level">
              <Box color={data.radiation > 50 ? 'bad' : 'good'}>
                {data.radiation} mSv
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Rad Shield">
              <Button
                content={data.rad_shield_on ? 'Active' : 'Inactive'}
                color={data.rad_shield_on ? 'good' : 'bad'}
                onClick={() => act('toggle_rad_shield')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>

        {data.last_scan_data &&
          data.last_scan_data !== 'No scans on record.' && (
            <Section title="Last Scan Report">
              <Box
                dangerouslySetInnerHTML={{ __html: data.last_scan_data }}
                style={{ fontFamily: 'monospace', fontSize: '0.85em' }}
              />
            </Section>
          )}
      </Window.Content>
    </Window>
  );
};
