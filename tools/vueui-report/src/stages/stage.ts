import { Signale } from 'signale'
import { ComponentOptions } from 'vue'

export interface Stage {
  name: () => string
  run: (Signale) => Promise<any>
  component: (any) => ComponentOptions<any>
  ci: boolean
}
