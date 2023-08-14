import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Flex, Table, Collapsible } from '../components';
import { NtosWindow } from '../layouts';

export type AwayShuttleData = {
	shuttle_manifest: ShuttleCrew[];
	active_record: ShuttleCrew;
};
	
type ShuttleCrew = {
	name: string;
	shuttle: string;
	id: number;
};

export const AwayShuttleManifest = (props, context) => {
	const { act, data } = useBackend<AwayShuttleData>(context);
	
	return (
		<NtosWindow resizable width={900} height={600}>
			<NtosWindow.Content scrollable>
				{data.active_record ? <ManifestEntryEdit /> : <AllShuttles />}
			</NtosWindow.Content>
		</NtosWindow>
	);
};

export const ManifestEntryEdit = (props, context) => {
	const { act, data } = useBackend<AwayShuttleData>(context);
	
	return (
		<Section
			title="Edit Manifest"
			buttons={
				<>
					<Button content="Back" onClick={() => act('am_menu')} />
					<Button
						content="Save"
						color="green"
						onClick={() => act('saveentry')}
					/>
					<Button
						content="Delete"
						color="red"
						onClick={() => act('deleteentry')}
					/>
				</>
			}>
		<LabeledList>
			<LabeledList.Item label="Name">
				{data.active_record.name}&nbsp;
				<Button
					icon="user"
					tooltip="Use a name found in the records."
					onClick={() => act('editentryname')}
				/>
				<Button
					icon="question"
					tooltip="Use a custom name."
					onClick={() => act('editentrynamecustom')}
				/>
			</LabeledList.Item>
			<LabeledList.Item label="Shuttle">
				{data.active_record.shuttle}&nbsp;
				<Button
					icon="info"
					tooltip="Change the shuttle for this entry."
					onClick={() => act('editentryshuttle')}
				/>
			</LabeledList.Item>
		</LabeledList>
  </Section>
	);
};

export const AllShuttles = (props, context) => {

	const { act, data } = useBackend<AwayShuttleData>(context);
	
	return (
		<>
			<Collapsible
				title="SCCV Canary"
				color="blue">
				<Section
					title="SCCV Canary"
					buttons={<Button content="Add Entry" onClick={() => act('addentry')} />
					}>
					{data.shuttle_manifest && data.shuttle_manifest.length ? (
						<Flex>
							<Table>
								<Table.Row header>
									<Table.Cell>Name</Table.Cell>
								</Table.Row>
								{data.shuttle_manifest
									.filter((m) => m.shuttle === 'SCCV Canary')
									.map((ShuttleCrew) => (
									<Table.Row key={ShuttleCrew.id}>
										<Table.Cell>
											<Flex.Item>
												<Button
													content={ShuttleCrew.name}
													onClick={() =>
														act('editentry', { editentry: ShuttleCrew.id })
													}
												/>
											</Flex.Item>
										</Table.Cell>
									</Table.Row>
									))}
							</Table>
						</Flex>
							) : (<NoticeBox>No crew detected.</NoticeBox>
							)}
				</Section>
			</Collapsible>
			<Collapsible
				title="SCCV Intrepid"
				color="purple">
				<Section
					title="SCCV Intrepid"
					buttons={<Button content="Add Entry" onClick={() => act('addentry')} />
					}>
					{data.shuttle_manifest && data.shuttle_manifest.length ? (
						<Flex>
							<Table>
								<Table.Row header>
									<Table.Cell>Name</Table.Cell>
								</Table.Row>
								{data.shuttle_manifest
									.filter((m) => m.shuttle === 'SCCV Intrepid')
									.map((ShuttleCrew) => (
									<Table.Row key={ShuttleCrew.id}>
										<Table.Cell>
											<Flex.Item>
												<Button
													content={ShuttleCrew.name}
													onClick={() =>
														act('editentry', { editentry: ShuttleCrew.id })
													}
												/>
											</Flex.Item>
										</Table.Cell>
									</Table.Row>
									))}
							</Table>
						</Flex>
							) : (<NoticeBox>No crew detected.</NoticeBox>
							)}
				</Section>
			</Collapsible>
			<Collapsible
				title="SCCV Spark"
				color="brown">
				<Section
					title="SCCV Spark"
					buttons={<Button content="Add Entry" onClick={() => act('addentry')} />
					}>
					{data.shuttle_manifest && data.shuttle_manifest.length ? (
						<Flex>
							<Table>
								<Table.Row header>
									<Table.Cell>Name</Table.Cell>
								</Table.Row>
								{data.shuttle_manifest
									.filter((m) => m.shuttle === 'SCCV Spark')
									.map((ShuttleCrew) => (
									<Table.Row key={ShuttleCrew.id}>
										<Table.Cell>
											<Flex.Item>
												<Button
													content={ShuttleCrew.name}
													onClick={() =>
														act('editentry', { editentry: ShuttleCrew.id })
													}
												/>
											</Flex.Item>
										</Table.Cell>
									</Table.Row>
									))}
							</Table>
						</Flex>
							) : (<NoticeBox>No crew detected.</NoticeBox>
							)}
				</Section>
			</Collapsible>
		</>
	);
};