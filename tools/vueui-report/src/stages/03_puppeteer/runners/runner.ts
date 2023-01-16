import { Page } from 'puppeteer'

export interface RunnerUtils {
  setSize(width: number, height: number): Promise<void>
  screenshot(name?: string): Promise<void>
  log(message: string): Promise<void>
  loadInitial(data: object): Promise<void>
}

export type Runner = {
  (page: Page, testFile: string, utils: RunnerUtils): Promise<void>
}
