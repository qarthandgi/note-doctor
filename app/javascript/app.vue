<template>
  <div id="app">
    <Navigation @to-route="toRoute" />
    <template v-if="dashboardRoute">
      <Dashboard :notes="allNotes" @to-route="toRoute" />
    </template>
    <template v-if="noteRoute">
      <Note @to-route="toRoute" :note="currentNote" />
    </template>
  </div>
</template>

<script>
import Dashboard from './components/dashboard'
import Note from './components/note'
import Navigation from './components/navigation'
export default {
  components: { Navigation, Dashboard, Note },
  data () {
    return {
      message: "Hello Vue!",
      route: 'dashboard',
      currentNote: null,
      allNotes: [],
    }
  },
  computed: {
    dashboardRoute() {
      return this.route === 'dashboard'
    },
    noteRoute() {
      return this.route === 'note'
    }
  },
  methods: {
    async getAll() {
      const resp = await fetch('http://localhost:3000/api/v1/progress_notes.json')
      const data = await resp.json()
      return data.sort((a, b) => a.updated_at < b.updated_at ? 1 : -1)
    },
    async toRoute({route, note}) {
      if (route === 'dashboard') {
        this.allNotes = await this.getAll()
        this.route = 'dashboard'
      } else {
        this.currentNote = note
        this.route = 'note'
      }
    }
  },
  async mounted() {
    this.allNotes = await this.getAll()
  }
}
</script>

<style>
p {
  font-size: 2em;
  text-align: center;
}
html, body {
  margin: 0;
  padding: 0;
  background-color: #f1f0ec;
}
</style>
