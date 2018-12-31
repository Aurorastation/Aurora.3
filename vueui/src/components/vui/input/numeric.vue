<template>
  <div>
    <vui-button v-for="bv in subButtons" :key="'-' + bv" :push-state="pushState" :disabled="val - bv < min" @click="onUpdatedValue(-bv)">-</vui-button>
    <input :style="{width: width}" ref="input" :value="val" @input="onFieldUpdate($event.target)"/>
    <vui-button v-for="bv in addButtons" :key="'+' + bv" :push-state="pushState" :disabled="val + bv > max" @click="onUpdatedValue(bv)">+</vui-button>
  </div>
</template>

<script>
import Store from '../../../store.js'
export default {
  props: {
    value: {
      type: Number,
      default: 0
    },
    buttonCount: {
      type: Number,
      default: 1
    },
    min: {
      type: Number,
      default: 0
    },
    max: {
      type: Number,
      default: 100
    },
    pushState: {
      type: Boolean,
      default: true
    },
    width: {
      type: String,
      default: '10em'
    },
    decimalPlaces: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      val: this.value
    }
  },
  computed: {
    subButtons() {
      if(!this.buttonCount) return [];
      let buttons = []
      for (let i = this.buttonCount - 1; i >= 0; i--) {
        buttons.push(10 ** i)
      }
      return buttons
    },
    addButtons() {
      if(!this.buttonCount) return [];
      let buttons = []
      for (let i = 0; i < this.buttonCount; i++) {
        buttons.push(10 ** i)
      }
      return buttons
    }
  },
  methods: {
    onFieldUpdate(field) {
      var _inival = this.val
      var int = Number(field.value)
      if(isNaN(int)) {
        int = this.val
      }
      console.log(int, field.value, this.value, this.val)
      this.UpdateValue(int)
      Store.pushState()
      if(_inival == this.val && !(field.value.endsWith("."))) {
        this.$refs.input.value = this.val
      }
    },
    onUpdatedValue(diff) {
      var int = this.value
      if(diff) {
        int += diff
      }
      this.UpdateValue(int)
    },
    UpdateValue(int) {
      int = +(Math.round(int + 'e+' + this.decimalPlaces) + 'e-' + this.decimalPlaces)
      if(int > this.max) int = this.max
      if(int < this.min) int = this.min
      this.val = int
      this.$emit('input', int);
    }
  },
  watch: {
    value() {
      this.val = this.value
    }
  }
}
</script>

<style lang="scss" scoped>
  div {
    display: inline-block;
  }
  input {
    text-align: center;
  }
</style>
