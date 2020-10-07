<template>
  <div class='container'>
    <div class="notes">
      <div class="new-note" @click="newNote">+</div>
      <div class="d-note" v-for="note in notes" :key="note.id" @click="onNote(note)">{{ note.note }}</div>
    </div>
    <div class="stats">
      <div class="trials" style="font-size:12px;font-weight:700;text-align:center;margin-bottom:10px;">
        <div>Trials Correct %</div>
        <VueSvgGauge
          :start-angle="-110"
          :end-angle="110"
          :value="trialsPercentage"
          :separator-step="10"
          :min="0"
          :max="100"
          :gauge-color="[{ offset: 0, color: '#402054'}, { offset: 100, color: '#e94726'}]"
          :scale-interval="1">
          <div class="inner-text"><div>{{ parseInt(trialsPercentage) }}%</div></div>
        </VueSvgGauge>
      </div>
      <div class="goals">
        <div class="stg goals-section">
          <div class="header">All Short Term Goals</div>
          <div class="a-goals" v-for="goal in shortTermGoals" :key="goal">{{ goal }}</div>
        </div>
        <div class="ltg goals-section">
          <div class="header">All Long Term Goals</div>
          <div class="a-goals" v-for="goal in longTermGoals" :key="goal">{{ goal }}</div>
        </div>
      </div>
    </div>
    <!-- <span> Dashboard </span>
    <button @click="newNote">New</button>
    <div v-for="note in notes" :key="note.id" @click="onNote(note)">{{note.id}} - {{note.note}}</div> -->
  </div>
</template>

<script>
import { VueSvgGauge } from 'vue-svg-gauge'

export default {
  components: { VueSvgGauge },
  props: ['notes'],
  data() {
    return {
      hello: 'hey',
      stats: {}
    }
  },
  computed: {
    trialsPercentage() {
      if (!this.stats || !this.stats.trials) {
        return 0
      }
      return (this.stats.trials.correct_trials / this.stats.trials.total_trials) * 100
    },
    shortTermGoals() {
      if (this.stats && this.stats.goals && this.stats.goals.short_term) {
        return this.stats.goals.short_term
      } else {
        return []
      }
    },
    longTermGoals() {
      if (this.stats && this.stats.goals && this.stats.goals.long_term) {
        return this.stats.goals.long_term
      } else {
        return []
      }
    }
  },
  methods: {
    onNote(note) {
      this.$emit('to-route', {route: 'note', note})
    },
    async getStats() {
      const resp = await fetch('/api/v1/note_features/stats')
      return resp.json()
    },
    async newNote() {
      const resp = await fetch('/api/v1/progress_notes', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({note: ''})
      })
      const note = await resp.json()
      console.log(note)
      this.$emit('to-route', {route: 'note', note})
    }
  },
  async mounted() {
    this.stats = await this.getStats()
  }
}
</script>

<style>
.container {
  padding-top: 20px;
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
}
.container > div {
  width: 50%;
}
.notes {
  display: flex;
  flex-flow: column nowrap;
  align-items: center
}
.notes > div {
  width: 70%;
  height: 80px;
  background-color: rgba(255, 255, 255, 0.6);
  margin-bottom: 38px;
  border-radius: 10px;
  white-space: pre;
  overflow: hidden;
  padding: 6px;
  font-size: 12px;
  color: #a9a9a9;
  box-sizing: border-box;
  border: 2px transparent solid;
  cursor: pointer;
}
.notes > div:hover {
  border: 2px gray solid;
}
.new-note {
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 40px !important;
  font-family: 'Ariel';
  color: #878787 !important;
}

.stats {
  display: flex;
  flex-flow: column nowrap;
  align-items: center;
}
.stats > div {
  width: 80%;
}
.inner-text {
  width: 100%;
  height: 100%;
  position: relative;
}
.inner-text div {
  position: absolute;
  bottom: 20px;
  left: 0;
  right: 0;
  margin: 0 auto;
}

.goals {
  margin-top: 70px;
  display: flex;
  justify-content: space-between;
}
.goals > .goals-section {
  width: 45%;
  /* border: 1px green solid; */
  border-radius: 10px;
  overflow: hidden;
}
.goals-section > .header {
  background-color: #782d44;
  color: white;
  font-size: 12px;
  font-weight: 700;
}
.goals-section > div {
  height: 30px;
  display: flex;
  justify-content: flex-start;
  align-items: center;
  padding: 10px;
  overflow: hidden;
  border-bottom: 1px white solid;
  white-space: nowrap;
}
</style>