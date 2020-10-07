<template>
  <div>
    <template v-if="mode == 0 || sel_price == 0">
      <div class="cancel-button">
        <vui-button v-if="coin" :params="{ remove_coin: 1 }" icon="sign-out-alt">{{ coin }}</vui-button>
      </div>
      <div class="t-parent">
        <vui-button :class="in_stock(vend_item.amount)" class="t-child tooltip" :disabled="vend_item.amount == 0 || mode == 1" push-state :params="{ vendItem: vend_item.key }" v-for="vend_item in products" :key="vend_item.key">
          <div class="t-container">
            <vui-img :class="in_stock(vend_item.amount)" class="food-icon" :name="getImage(vend_item)"/>
            <span v-if="vend_item.price > 0" class="cart-icon fas ic-shopping-cart"/>
            <span v-if="vend_item.price > 0" class="price">{{ vend_item.price }}电</span>
            <span class="qty" :class="in_stock(vend_item.amount)">(x{{ vend_item.amount }})</span>
          </div>
          <span class="tooltiptext">{{ vend_item.name }}</span>
        </vui-button>
      </div>
    </template>
    <template v-else-if="sel_name && sel_price > 0">
      <div class="t-parent">
        <p>Purchasing<vui-img class="purchase-icon" v-if="$root.$data.assets[sel_key]" :name="sel_key" />{{sel_name}} for {{sel_price}}电:</p>
        <p>Swipe ID or insert credits to purchase.</p>
        <p v-if="message_err == 1" class="danger">{{message}}</p>
        <div class="cancel-button">
          <vui-button :params="{ cancelpurchase: 1 }" icon="undo">Cancel Transaction</vui-button>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  methods: {
    in_stock: function(amt) {
      if (amt <= 0) {
        return "no-stock";
      } else {
        return "";
      }
    },
    getImage: function(i) {
      if (i.amount == 0) {
        return i.key + "g"
      } else {
        return i.key
      }
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
  height: 75%;
}

.t-parent {
  text-align: center;
  display: flex;
  flex-wrap: wrap;
  background-color: rgba(0, 0, 0, 0.4);
  outline-style: ridge;
  outline-color: black;
  justify-content: space-evenly;
}

.t-child {
  width: 22.5%;
  height: auto;
  white-space: normal;
  box-sizing: border-box;
  margin: 4px 4px 4px 4px;
  background-color: rgba(64, 98, 138, 0.4);
}

.t-container {
  height: 100px;
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