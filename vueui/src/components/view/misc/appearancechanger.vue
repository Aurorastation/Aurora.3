<template>
  <div>
    <div v-if="change_race">
      <div class="item">
        <div class="itemLabelNarrow">
          Species:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="species in valid_species" :class="{'button' : 1, 'selected' : owner_species == species}" :params="{ race: species }" :key="species">{{ species }}</vui-button>
        </div>
      </div>
    </div>
    <div v-if="change_gender">
      <div class="item">
        <div class="itemLabelNarrow">
          Sex:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="gender in valid_gender" :class="{'button' : 1, 'selected' : owner_gender == gender}" :params="{ gender: gender }" :key="gender">{{ gender }}</vui-button>
        </div>
        <div v-if="valid_pronouns.length" class="itemLabelNarrow">
          Pronouns:
        </div>
        <div v-if="valid_pronouns.length" class="itemContentWide">
          <vui-button v-for="pronouns in valid_pronouns" :class="{'button' : 1, 'selected' : owner_pronouns == pronouns}" :params="{ pronouns: pronouns }" :key="pronouns">{{ pronouns }}</vui-button>
        </div>
      </div>
    </div>
    <div v-if="change_culture">
      <div class="item">
        <div class="itemLabelNarrow">
          Cultures:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="culture in valid_cultures" :class="{'button' : 1, 'selected' : owner_culture == culture}" :params="{ culture: culture }" :key="culture">{{ culture }}</vui-button>
        </div>
        <div class="itemLabelNarrow">
          Origins:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="origin in valid_origins" :class="{'button' : 1, 'selected' : owner_origin == origin}" :params="{ origin: origin }" :key="origin">{{ origin }}</vui-button>
        </div>
        <div class="itemLabelNarrow">
          Citizenships:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="citizenship in valid_citizenships" :class="{'button' : 1, 'selected' : owner_citizenship == citizenship}" :params="{ citizenship: citizenship }" :key="citizenship">{{ citizenship }}</vui-button>
        </div>
        <div class="itemLabelNarrow">
          Accents:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="accent in valid_accents" :class="{'button' : 1, 'selected' : owner_accent == accent}" :params="{ accent: accent }" :key="accent">{{ accent }}</vui-button>
        </div>
      </div>
    </div>
    <div v-if="change_language && valid_languages.length">
      <div class="item">
        <div class="itemLabelNarrow">
          Languages:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="language in valid_languages" :class="{'button' : 1, 'selected' : ArrayContains(owner_languages, language)}" :params="{ language: language }" :key="language">{{ language }}</vui-button>
        </div>
      </div>
    </div>
    <div v-if="change_eye_color || change_skin_tone || change_skin_color || change_hair_color || change_facial_hair_color">
      <div class="item">
        <div class="itemLabelNarrow">
          Colors:
        </div>
        <div class="itemContentWide">
          <vui-button v-if="change_eye_color" :params="{ eye_color : 1 }">Change Eye Color</vui-button>
          <vui-button v-if="change_skin_tone" :params="{ skin_tone : 1 }">Change Skin Tone</vui-button>
          <vui-button v-if="change_skin_preset" :params="{ skin_preset : 1 }">Change Skin Preset</vui-button>
          <vui-button v-if="change_skin_color && !change_skin_preset" :params="{ skin_color : 1 }">Change Skin Color</vui-button>
          <vui-button v-if="change_hair_color" :params="{ hair_color : 1 }">Change Hair Color</vui-button>
          <vui-button v-if="change_facial_hair_color" :params="{ facial_hair_color : 1 }">Change Facial Hair Color</vui-button>
        </div>
      </div>
    </div>
    <div v-if="change_hair && valid_hair_styles.length">
      <div class="item">
        <div class="itemLabelNarrow">
          Hair Styles:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="hair_style in valid_hair_styles" :class="{'button' : 1, 'selected' : owner_hair_style == hair_style}" :params="{ hair: hair_style }" :key="hair_style">{{ hair_style }}</vui-button>
        </div>
      </div>
    </div>
    <div v-if="change_facial_hair && valid_facial_hair_styles.length">
      <div class="item">
        <div class="itemLabelNarrow">
          Facial Hair Styles:
        </div>
        <div class="itemContentWide">
          <vui-button v-for="facial_hair_style in valid_facial_hair_styles" :class="{'button' : 1, 'selected' : owner_facial_hair_style == facial_hair_style}" :params="{ facial_hair: facial_hair_style }" :key="facial_hair_style">{{ facial_hair_style }}</vui-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  methods: {
    ArrayContains(array, string) {
      if(array.includes(string)) {
        return true
      } else {
        return false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
* {
  text-transform: capitalize;
}
</style>