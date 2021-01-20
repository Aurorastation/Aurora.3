<template>
  <div>
    <div v-for="(row, rowi) in boardTiles" :key="rowi" class="tileRow">
      <div
        v-for="(tile, coli) in row"
        :key="coli"
        class="tile"
        :class="tile.tile + (selectedTile == tile.pos ? ' sel' : '')"
        @click.stop="handleTileClick(tile.pos)"
      >
        <div
          v-if="getPiece(tile.pos)"
          class="piece fa"
          :class="
            getPieceClass(tile.pos) + (selected == tile.pos ? ' sel' : '')
          "
          @click.stop="handlePieceClick(tile.pos)"
        />
      </div>
    </div>
    <template v-if="selected != null">
      <vui-button @click="removePiece">Remove</vui-button>
    </template>
    <template v-if="selectedTile != null">
      <div>
        Red: <vui-button v-for="(t, ti) in types" :key="'r' + ti" :icon="t.i" @click="spawn(t.k, 'red')">{{ t.n }}</vui-button>
      </div>
      <div>
        Black: <vui-button v-for="(t, ti) in types" :key="'b' + ti" :icon="t.i" @click="spawn(t.k, 'black')">{{ t.n }}</vui-button>
      </div>
    </template>
  </div>
</template>

<script>
import Utils from '../../../../utils'
const board = "wbwbwbwbbwbwbwbwwbwbwbwbbwbwbwbwwbwbwbwbbwbwbwbwwbwbwbwbbwbwbwbw"
const chunk = (arr, size) =>
  Array.from({ length: Math.ceil(arr.length / size) }, (v, i) =>
    arr.slice(i * size, i * size + size)
  )
const piecePurify = p => ({type: p.type, faction: p.faction, pos: p.pos})
const icons = {
  c: "circle",
  "c-k": "dot-circle",
  "h-ki": "chess-king",
  "h-qe": "chess-queen",
  "h-b": "chess-bishop",
  "h-k": "chess-knight",
  "h-r": "chess-rook",
  "h-p": "chess-pawn",
}
const names = {
  c: "Cheker",
  "c-k": "Marked Checker",
  "h-ki": "King",
  "h-qe": "Queen",
  "h-b": "Bishop",
  "h-k": "Knight",
  "h-r": "Rook",
  "h-p": "Pawn",
}
export default {
  data() {
    return {
      s: this.$root.$data.state,
      selected: null,
      selectedTile: null,
      types: Object.keys(names).map((k) => ({n: names[k], i: icons[k], k}))
    }
  },
  computed: {
    boardTiles() {
      return chunk(
        Array.from(Array(64).keys(), (_, i) => ({ pos: i, tile: board[i] })),
        8
      )
    },
  },
  methods: {
    getPiece(pos) {
      const found = this.s.pieces.find(v => v.pos == pos)
      if (!found) {
        if(this.s.last && this.s.last.pos == pos)
          return {index: -1, ghost: true, ...this.s.last }
        else
          return null
      }
      const index = this.s.pieces.indexOf(found) + 1
      return { index, ghost: false, ...found }
    },
    getPieceClass(pos) {
      const piece = this.getPiece(pos)
      return 'ic-' + icons[piece.type] + ' ' + piece.faction + (piece.ghost ? ' ghost' : '')
    },
    removePiece() {
      const piece = this.getPiece(this.selected)
      Utils.sendToTopic({ remove: { index: piece.index} })
      this.selected = null
    },
    spawn(type, faction) {
      const piece = this.getPiece(this.selectedTile)
      if(piece && !piece.ghost) {
        return 
      }
      Utils.sendToTopic({ add: { piece: {type, faction, pos: this.selectedTile}} })
      this.selectedTile = null
    },
    handlePieceClick(pos) {
      if(this.selectedTile != null)
      {
        return;
      }
      const piece = this.getPiece(pos)
      if(this.selected == pos)
      {
        this.selected = null
      } else {
        if(piece && !piece.ghost)
          this.selected = pos
      }
    },
    handleTileClick(pos) {
      if(this.selected != null)
      {
        const piece = this.getPiece(this.selected)
        // Move selected to this tile
        Utils.sendToTopic({ change: { piece: {...piecePurify(piece), pos}, index: piece.index} })
        this.selected = null
        return
      }
      if(this.selectedTile == pos)
      {
        this.selectedTile = null
      } else {
        this.selectedTile = pos
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.tileRow {
  line-height: 1em;
  cursor: pointer;
  .tile {
    height: 3em;
    width: 3em;
    padding: 0.5em;
    display: inline-block;
    vertical-align: bottom;

    .piece {
      font-size: 3em;
      line-height: 1em;
      text-align: center;

      -webkit-user-select: none; /* Safari */        
      -moz-user-select: none; /* Firefox */
      -ms-user-select: none; /* IE10+/Edge */
      user-select: none; /* Standard */

      &.ghost {
        opacity: 0.6;
      }

      &.sel {
        text-shadow: 2px 0px 10px rgba(83, 83, 255, 1);
      }

      &.black {
        color: blue;
      }

      &.red {
        color: red;
      }
    }

    &.w {
      background-color: white;

      &.sel {
        background-color: rgb(180, 172, 255);
      }
    }

    &.b {
      background-color: black;

      &.sel {
        background-color: rgb(10, 0, 99);
      }
    }
  }
}
</style>
