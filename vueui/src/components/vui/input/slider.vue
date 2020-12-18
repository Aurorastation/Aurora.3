<template>
  <div>
    <input
      type="range"
      :min="min"
      :max="max"
      :style="{ width: width }"
      ref="input"
      :value="val"
      @change="onFieldUpdate($event.target)"
    />
  </div>
</template>

<script>
import Store from '@/store'
export default {
  props: {
    value: {
      type: Number,
      default: 0,
    },
    min: {
      type: Number,
      default: 0,
    },
    max: {
      type: Number,
      default: 100,
    },
    pushState: {
      type: Boolean,
      default: true,
    },
    width: {
      type: String,
      default: '10em',
    },
    decimalPlaces: {
      type: Number,
      default: 0,
    },
  },
  data() {
    return {
      val: this.value,
    }
  },
  methods: {
    onFieldUpdate(field) {
      var _inival = this.val
      var int = Number(field.value)
      if (isNaN(int)) {
        int = this.val
      }
      console.log(int, field.value, this.value, this.val)
      this.UpdateValue(int)
      if (_inival == this.val && !field.value.endsWith('.')) {
        this.$refs.input.value = this.val
      }
    },
    onUpdatedValue(diff) {
      var int = this.value
      if (diff) {
        int += diff
      }
      this.UpdateValue(int)
    },
    UpdateValue(int) {
      int = +(Math.round(int + 'e+' + this.decimalPlaces) + 'e-' + this.decimalPlaces)
      if (int > this.max) int = this.max
      if (int < this.min) int = this.min
      this.val = int
      this.$emit('input', int)
      if (this.pushState) Store.pushState()
    },
  },
  watch: {
    value() {
      this.val = this.value
    },
  },
}
</script>

<style lang="scss" scoped>
div {
  display: inline-block;
}
input {
  text-align: center;
}
input[type='range'] {
  width: 100%;
  border: none;
}
input[type='range']:focus {
  outline: none;
}
input[type='range']::-ms-track {
  width: 100%;
  height: 8.4px;
  cursor: pointer;
  background: transparent;
  border-color: transparent;
  border-width: 16px 0;
  color: transparent;
}
input[type='range']::-ms-fill-lower {
  background: #2a6495;
  border: 0.2px solid #010101;
  border-radius: 2.6px;
  box-shadow: 1px 1px 1px #000000, 0px 0px 1px #0d0d0d;
}
input[type='range']::-ms-fill-upper {
  background: #3071a9;
  border: 0.2px solid #010101;
  border-radius: 2.6px;
  box-shadow: 1px 1px 1px #000000, 0px 0px 1px #0d0d0d;
}
input[type='range']::-ms-thumb {
  box-shadow: 1px 1px 1px #000000, 0px 0px 1px #0d0d0d;
  border: 1px solid #000000;
  height: 16px;
  width: 8px;
  border-radius: 2px;
  background: #ffffff;
  cursor: pointer;
}
input[type='range']:focus::-ms-fill-lower {
  background: #3071a9;
}
input[type='range']:focus::-ms-fill-upper {
  background: #367ebd;
}
</style>
