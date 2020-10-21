<template>
  <div>
    <template v-if="s.mode == 0 || s.sel_price == 0">
      <div class="cancel-button">
        <vui-input-search :input="products" v-model="output" :keys="['name']" autofocus :threshold="threshold" />
        <vui-button :disabled="!s.coin" :params="{ remove_coin: 1 }" icon="sign-out-alt">{{ s.coin ? s.coin : "No coin inserted." }}</vui-button>
      </div>
      <div class="t-parent">
        <vui-button v-for="vend in output" :key="vend.key" :class="vend.amount > 0 ? '' : 'no-stock'"
                    class="t-child tooltip" :disabled="vend.amount == 0 || s.mode == 1" :params="{ vendItem: vend.key }">
          <div class="t-container" :style="{ height: s.ui_size + 'px', width: s.ui_size + 'px'}">
            <span :class="[vend.amount > 0 ? '' : 'no-stock', vend.icon_tag]" class="food-icon"/>
            <span v-if="vend.price > 0" class="cart-icon fas ic-shopping-cart"/>
            <span v-if="vend.price > 0" class="price">{{ vend.price }}电</span>
            <span class="qty" :class="vend.amount > 0 ? '' : 'no-stock'">(x{{ vend.amount }})</span>
          </div>
          <span class="tooltiptext">{{ vend.name }}</span>
        </vui-button>
      </div>
    </template>
    <template v-else-if="s.sel_name && s.sel_price > 0">
      <div class="t-parent">
        <p>Item selected:<span class="purchase-icon" :class="s.sel_icon" />{{s.sel_name}}</p>
        <p>Charge: {{s.sel_price}}电 / {{s.sel_price}}cr</p>
        <p>Swipe your NanoTrasen ID or insert credits to purchase.</p>
        <p v-if="s.message_err == 1" class="danger">{{s.message}}</p>
        <div class="cancel-button">
          <vui-button :params="{ cancelpurchase: 1 }" icon="undo">Cancel Transaction</vui-button>
        </div>
      </div>
    </template>
    <template v-else>
      <vui-button class="cancel-button danger" :params="{ reset: 1}" icon="undo">Reset Machine</vui-button>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      output: [],
      threshold: 0.3
    }
  },
  computed: {
    products() {
      return Object.values(this.s.products);
    }
  }
};
</script>

<style lang="scss" scoped>

.t-parent > p {
  text-align: center;
  margin-top: 0px;
  width: 100%;
}

.cancel-button {
  width: 100%;
  margin-bottom: 5px;
}

p.danger {
  color: red;
}

.purchase-icon {
  vertical-align: bottom;
}

.food-icon {
  // zoom: 2;
  transform: scale(2);
  position: absolute;
  left: 0;
  right: 0;
  margin-left: auto;
  margin-right: auto;
  margin-top: 12px;
}

.food-icon.no-stock {
  opacity: 0.2;
  filter: alpha(opacity=20);
  -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=20)";
  // god knows which one of these we actually need so let's just use them all
}

.t-parent {
  text-align: center;
  display: flex;
  flex-wrap: wrap;
  background-color: rgba(0, 0, 0, 0.4);
  outline-style: ridge;
  outline-color: black;
}

.t-child {
  height: auto;
  white-space: normal;
  box-sizing: border-box;
  margin: 4px 4px 4px 4px;
  background-color: rgba(64, 98, 138, 0.4);
}

.t-container {
  position: relative;
}

.statusValue {
  width: 90%;
}

.no-stock {
  color: gray;
}

.cart-icon {
  position: absolute;
  bottom: 5px;
  left: 0px;
}

.price {
  position: absolute;
  bottom: 4px;
  left: 0;
  right: 15px;
  text-align: center;
  font-size: 10px;
}

.qty {
  position: absolute;
  right: 0;
  bottom: 4px;
  font-size: 10px;
}

.no-stock.button {
  background: inherit;
  border-style: none;
}

/* Tooltip container */
.tooltip {
  position: relative;
  display: inline-block;
}

/* Tooltip text */
.tooltip .tooltiptext {
  visibility: hidden;
  width: 120px;
  background-color: #202020;
  color: #fff;
  text-align: center;
  padding: 5px 0;
  border-radius: 6px;
  opacity: 0;
  transition: opacity 1s;

  position: absolute;
  z-index: 1;
  bottom: 100%;
  left: 50%;
  margin-left: -60px;
  right: auto;
}

.tooltip .tooltiptext::after {
  content: " ";
  position: absolute;
  top: 100%;
  left: 50%;
  border-width: 5px;
  border-style: solid;
  border-color: #202020 transparent transparent transparent;
}

.tooltip:hover .tooltiptext {
  visibility: visible;
  opacity: 1;
}

</style>