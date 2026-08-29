import { NoticeBox, Tabs } from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { NtosWindow } from '../layouts';
import { type DiagnosticsData, IPCDiagnostics } from './IPCDiagnostics';
import { SurgeryPlanner, type SurgeryPlannerData } from './SurgeryPlanner';

type RoboticsData = DiagnosticsData &
  SurgeryPlannerData & {
    diagnostic_mode: 'ipc' | 'prosthetic' | null;
  };

export const RoboticsComputer = (props) => {
  const { data } = useBackend<RoboticsData>();
  const [tab, setTab] = useLocalState<'diagnostics' | 'planner'>(
    'roboticsComputerTab',
    'diagnostics',
  );

  const diagnosticsLabel =
    data.diagnostic_mode === 'prosthetic'
      ? 'Cybernetic Diagnostics'
      : 'Synthetic Diagnostics';

  return (
    <NtosWindow resizable width={1050} height={700} theme="hephaestus">
      <NtosWindow.Content scrollable>
        {!data.has_patient ? (
          <NoticeBox>
            Connect the access cable to an IPC access port or a targeted
            prosthetic limb or cybernetic service jack.
          </NoticeBox>
        ) : (
          <>
            <Tabs fluid>
              <Tabs.Tab
                icon="stethoscope"
                selected={tab === 'diagnostics'}
                onClick={() => setTab('diagnostics')}
              >
                {diagnosticsLabel}
              </Tabs.Tab>
              <Tabs.Tab
                icon="screwdriver-wrench"
                selected={tab === 'planner'}
                onClick={() => setTab('planner')}
              >
                Surgery Planning
              </Tabs.Tab>
            </Tabs>

            {tab === 'diagnostics' ? (
              <IPCDiagnostics />
            ) : (
              <SurgeryPlanner contentOnly plannerOnly syntheticMode />
            )}
          </>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
