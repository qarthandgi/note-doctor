<template>
  <div class='note-container'>
    <div class="input-area">
      <textarea v-model="note.note" name="" id="" cols="30" rows="50"></textarea>
    </div>
    <div class="rts">
      <button class='save' @click="createFeatures">SAVE NOTE</button>
      <div class="rts-trials">
        <div class="trial">
          <div class='header'>Trials Correct</div>
          <VueSvgGauge
            :start-angle="-110"
            :end-angle="110"
            :value="positiveTrials"
            :separator-step="10"
            :min="0"
            :max="negativeTrials + positiveTrials"
            :gauge-color="[{ offset: 0, color: '#402054'}, { offset: 100, color: '#e94726'}]"
            :scale-interval="1">
            <div class="inner-text"><div>{{ positiveTrials }}</div></div>
          </VueSvgGauge>
        </div>
        <div class="trial">
          <div class='header'>Trials Incorrect</div>
          <VueSvgGauge
            :start-angle="-110"
            :end-angle="110"
            :value="negativeTrials"
            :separator-step="10"
            :min="0"
            :max="negativeTrials + positiveTrials"
            :gauge-color="[{ offset: 0, color: '#402054'}, { offset: 100, color: '#e94726'}]"
            :scale-interval="1">
            <div class="inner-text"><div>{{ negativeTrials }}</div></div>
          </VueSvgGauge>
        </div>
        <div class="trial">
          <div class='header'>Total Trials</div>
          <div class="main">{{ negativeTrials + positiveTrials }}</div>
        </div>
      </div>
      <div class="goals" style="width:90%;margin:0 auto;">
        <div class="stg goals-section">
          <div class="header">All Short Term Goals</div>
          <div class="a-goals" v-for="goal in shortTermGoals" :key="goal">{{ goal }}</div>
        </div>
        <div class="ltg goals-section">
          <div class="header">All Long Term Goals</div>
          <div class="a-goals" v-for="goal in longTermGoals" :key="goal">{{ goal }}</div>
        </div>
      </div>
      <div class="goals" style="width:90%;margin:40px auto;">
        <div class="stg goals-section">
          <div class="header">Phonetic Sounds Practiced</div>
          <div class="a-goals" v-for="mp in matchedPhonetics" :key="mp">{{ mp }}</div>
        </div>
        <div class="ltg goals-section">
          <div class="header">Word Errors</div>
          <div class="a-goals" v-for="error in errors" :key="error">{{ error }}</div>
        </div>
      </div>
    </div>
    <!-- <button @click="$emit('to-route', {route: 'dashboard'})">To Dashboard</button>
    <span> Note {{ note.note }} </span>
    <button @click="createFeatures">Create Features</button> -->
  </div>
</template>

<script>
import { VueSvgGauge } from 'vue-svg-gauge'

export default {
  components: { VueSvgGauge },
  props: ['note'],
  data() {
    return {
      hello: 'hey',
    }
  },
  computed: {
    negativeTrials() {
      return this.note.note.split('').filter(x => x === '-').length
    },
    positiveTrials() {
      return this.note.note.split('').filter(x => x === '+').length
    },
    matchedPhonetics() {
      const re = /\/(.*)\//g
      const arr = [...this.note.note.matchAll(re)]
      const reduced = arr.reduce((acc, item) => [...acc, ...item[0].split(' ')], [])
      const filtered = reduced.filter(x => x.match(/\/(\w*)\//g))
      return filtered.map(x => x.slice(1, -1))
    },
    shortTermGoals() {
      const arr = [...this.note.note.matchAll(/STG\d:\s?(.*)/g)]
      return arr.map(x => x[1])
    },
    longTermGoals() {
      const arr = [...this.note.note.matchAll(/LTG\d:\s?(.*)/g)]
      return arr.map(x => x[1])
    },
    errors() {
      const arr = [...this.note.note.matchAll(/errors:\s?(.*)/g)]
      return arr.reduce((acc, item) => [...acc, ...item[1].split(' ')], [])
    },
    errorFeatures() {
      return this.errors.map(x => {
        return {feature_type: 'error', value: x, text_idx: 0}
      })
    },
    shortTermGoalFeatures() {
      return this.shortTermGoals.map(x => {
        return {feature_type: 'stg', value: x, text_idx: 0}
      })
    },
    longTermGoalFeatures() {
      return this.longTermGoals.map(x => {
        return {feature_type: 'ltg', value: x, text_idx: 0}
      })
    },
    trialSeriesFeatures() {
      const totalTrials = this.negativeTrials + this.positiveTrials
      return [{feature_type: 'trialSeries', value: `${this.positiveTrials}/${totalTrials}`, text_idx: 0}]
    },
    phoneticsFeatures() {
      return this.matchedPhonetics.map(x => {
        return {feature_type: 'phonetics', value: x, text_idx: 0}
      })
    }
  },
  methods: {
    async createFeatures() {
      // let data = [
      //   {feature_type: 'trialSeries', value: '3/10', text_idx: 3},
      //   {feature_type: 'trialSeries', value: '3/10', text_idx: 5},
      //   {feature_type: 'stg', value: 'Work on animals that begin with /sh/', text_idx: 4},
      //   {feature_type: 'ltg', value: 'Working on getting all animal sounds correct', text_idx: 7},
      //   {feature_type: 'phonetics', value: 'sh', text_idx: 8},
      //   {feature_type: 'error', value: 'sheep', text_idx: 193}
      // ]
      let data = [
        ...(this.shortTermGoalFeatures || []),
        ...(this.longTermGoalFeatures || []),
        ...(this.trialSeriesFeatures || []),
        ...(this.errorFeatures || []),
        ...(this.phoneticsFeature || [])
      ]
      data = data.map(x => ({...x, progress_note_id: this.note.id}))
      console.log(data)
      const featuresResp = await fetch('/api/v1/note_features.json', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      })
      await featuresResp.json()

      const noteResp = await fetch(`/api/v1/progress_notes/${this.note.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(this.note)
      })
      await noteResp.json()

      this.$emit('to-route', {route: 'dashboard'})

    }
  }
}
</script>

<style>
.note-container {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
}
.note-container > div {
  width: 50%;
}
.input-area {
  /* border: 1px red solid; */
}
.input-area textarea {
  width: 100%
}
.rts {
  text-align: center;
}
.rts-trials {
  width: 90%;
  margin: 0 auto;
  display: flex;
}
.rts-trials .trial {
  flex: 1;
  height: 200px;
  padding: 30px;
}
.rts-trials .trial .header {
  text-align: center;
  font-weight: 700;
  font-size: 11px;
}
.rts-trials .trial .main {
  font-weight: 600;
  font-size: 32px;
  margin-top: 80px;
  text-align: center;
}

.goals-section {
  max-height: 400px;
}
.inner-text {
  width: 100%;
  height: 100%;
  position: relative;
  text-align: center;
  font-weight: 700;
}
.inner-text div {
  position: absolute;
  bottom: 20px;
  left: 0;
  right: 0;
  margin: 0 auto;
  font-size: 18px;
}

.save {
  background-color: #e94726;
  color: white;
  margin: 0 auto;
  width: 200px;
  text-align: center;
  height: 30px;
  margin-top: 20px;
  border: none;
  outline: none;
  font-size: 16px;
  font-weight: 700;
  border-radius: 4px;
  cursor: pointer;
}
</style>