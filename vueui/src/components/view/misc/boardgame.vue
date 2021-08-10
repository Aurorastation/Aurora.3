<template>
  <div>
    <vui-button @click="fliped = !fliped">Flip</vui-button>
    <div class="text-center">
      <div v-for="(row, rowi) in boardTiles" :key="rowi" class="tileRow">
        <div
          v-for="(tile, coli) in row"
          :key="rowi + '' + coli"
          class="tile"
          :class="tile.tile + (selected == tile.pos ? ' sel' : '')"
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
    </div>
    <template v-if="selected != null">
      <template v-if="isPiece(selected)">
        <vui-button @click="removePiece">Remove</vui-button>
      </template>
      <template v-else>
        <div class="mt-1">
          Red: <vui-button v-for="(t, ti) in types" :key="'r' + ti" :icon="t.i" @click="spawn(t.k, 'red')">{{ t.n }}</vui-button>
        </div>
        <div>
          Black: <vui-button v-for="(t, ti) in types" :key="'b' + ti" :icon="t.i" @click="spawn(t.k, 'black')">{{ t.n }}</vui-button>
        </div>
      </template>
    </template>
    <template v-else-if="!s.pieces.length">
      <vui-button @click="presetCheckers">Initialize checker board</vui-button>
      <vui-button @click="presetChess">Initialize chess board</vui-button>
    </template>
    
    
  </div>
</template>

<script>
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
  c: "Checker",
  "c-k": "Marked Checker",
  "h-ki": "King",
  "h-qe": "Queen",
  "h-b": "Bishop",
  "h-k": "Knight",
  "h-r": "Rook",
  "h-p": "Pawn",
}

const factionPresetter = (faction) => (t) => t ? {t, f: faction} : t 

const checkersPreset = [
  [null, 'c', null, 'c', null, 'c', null, 'c'].map(factionPresetter('red')),
  ['c', null, 'c', null, 'c', null, 'c', null].map(factionPresetter('red')),
  [null, 'c', null, 'c', null, 'c', null, 'c'].map(factionPresetter('red')),
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  ['c', null, 'c', null, 'c', null, 'c', null].map(factionPresetter('black')),
  [null, 'c', null, 'c', null, 'c', null, 'c'].map(factionPresetter('black')),
  ['c', null, 'c', null, 'c', null, 'c', null].map(factionPresetter('black')),
].flat()

const chessPreset = [
  ['h-r', 'h-k', 'h-b', 'h-ki', 'h-qe', 'h-b', 'h-k', 'h-r'].map(factionPresetter('red')),
  ['h-p', 'h-p', 'h-p', 'h-p', 'h-p', 'h-p', 'h-p', 'h-p'].map(factionPresetter('red')),
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  [null, null, null, null, null, null, null, null],
  ['h-p', 'h-p', 'h-p', 'h-p', 'h-p', 'h-p', 'h-p', 'h-p'].map(factionPresetter('black')),
  ['h-r', 'h-k', 'h-b', 'h-ki', 'h-qe', 'h-b', 'h-k', 'h-r'].map(factionPresetter('black')),
].flat()

export default {
  data() {
    return {
      s: this.$root.$data.state,
      selected: null,
      types: Object.keys(names).map((k) => ({n: names[k], i: icons[k], k})),
      fliped: false
    }
  },
  computed: {
    boardTiles() {
      const initial = Array.from(Array(64).keys(), (_, i) => ({ pos: i, tile: board[i] }))
      return chunk(
        this.fliped ? initial.reverse() : initial,
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
    isPiece(pos, piece = null) {
      if(!piece) {
        piece = this.getPiece(pos)
      }
      return piece && !piece.ghost
    },
    getPieceClass(pos) {
      const piece = this.getPiece(pos)
      return 'ic-' + icons[piece.type] + ' ' + piece.faction + (piece.ghost ? ' ghost' : '')
    },
    removePiece() {
      const piece = this.getPiece(this.selected)
      this.$toTopic({ remove: { index: piece.index} })
      this.selected = null
    },
    spawn(type, faction) {
      const piece = this.getPiece(this.selected)
      if(piece && !piece.ghost) {
        return 
      }
      this.qspawn(type, faction, this.selected)
      this.selected = null
    },
    qspawn(type, faction, pos) {
      this.$toTopic({ add: { piece: {type, faction, pos}} })
    },
    handlePieceClick(pos) {
      if(!this.isPiece(pos)) {
        return this.handleTileClick(pos)
      }
      if(this.selected == pos)
      {
        this.selected = null
      } else {
        this.selected = pos
      }
    },
    handleTileClick(pos) {
      if(this.selected == pos)
      {
        this.selected = null
      } else if (this.selected != null) {
        const piece = this.getPiece(this.selected)
        if(this.isPiece(null, piece) && !this.isPiece(pos)) {
        // Move selected to this tile
          this.$toTopic({ change: { piece: {...piecePurify(piece), pos}, index: piece.index} })
        }
        this.selected = null
      } else {
        this.selected = pos
      }
    },
    presetChess() {
      chessPreset.forEach((val, p) => val ? this.qspawn(val.t, val.f, p) : '');
    },
    presetCheckers() {
      checkersPreset.forEach((val, p) => val ? this.qspawn(val.t, val.f, p) : '');
    }
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

        &.sel {
          text-shadow: none;
        }
      }

      &.sel {
        text-shadow: 2px 0px 10px rgba(83, 83, 255, 1);
      }

      &.black {
        color: black;
      }

      &.red {
        color: red;
      }
    }

    &.w {
      background-color: #66ccff;

      &.sel {
        background-color: #A5CCFF;
      }
    }

    &.b {
      background-color: #3a3a3d;

      &.sel {
        background-color: #4C3A3D;
      }
    }
  }
}
</style>
