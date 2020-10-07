<template>
    <div class="bar">
        <img @click="$emit('to-route', {route: 'dashboard'})" src="~images/note_doctor.png" alt="">
    </div>
</template>

<style>
.bar {
    height: 100px;
    border-bottom: 2px #ffffff solid;
    display: flex;
    justify-content: center;
    align-items: center;
}
img {
    width: 400px;
    cursor: pointer;
}
</style>