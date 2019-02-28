<template>
  <div>
    <h1>Welcome to View testing file.</h1>
    You can open this file inside any regular browser to inspect what is going on client side.
    If you are seeing this, it means, you haven't setup proper data in <code>template.html</code>
    <p style="font-size: 2em; font-weight: bold;" v-if="!env_dev">WARNING: VueUi is currently built in production mode, for optimal experience please build it in development mode, on how to do it, please refer to README.md</p>
  </div>
</template>

<script>
export default {
  data() {
    return {
      env_dev: process.env.NODE_ENV === 'development'
    }
  }
}
</script>