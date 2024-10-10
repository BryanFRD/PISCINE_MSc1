<!-- eslint-disable prettier/prettier -->
<script setup>
import moment from "moment";
import { Edit3, Loader2, Plus, Trash2, Undo, User2 } from "lucide-vue-next";
import { onMounted, ref, watch } from "vue";
import { useRoute } from "vue-router";

import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";

import { instance } from "../../api/instance";
import EditWorkingTimeDialog from "./EditWorkingTimeDialog.vue";

const route = useRoute();

const workingTime = ref({
  id: null,
  start: null,
  end: null,
});

const workingTimeLoading = ref(false);
const workingTimeError = ref(null);
const workingTimeDay = ref(null);
const workingTimeStart = ref(null);
const workingTimeEnd = ref(null);

const getWorkingTime = async (userId, workingTimeId) => {
  try {
    workingTimeLoading.value = true;
    const result = await instance.get(`/workingtimes/${userId}/${workingTimeId}`);
    workingTime.value.id = result.data.id;
    workingTime.value.start = result.data.start;
    workingTime.value.end = result.data.end;
  } catch {
    workingTimeError.value = "Failed to fetch working time";
  } finally {
    workingTimeLoading.value = false;
    workingTimeDay.value = moment(workingTime.value.start).format("MMMM Do YYYY");
    workingTimeStart.value = moment(workingTime.value.start).format("HH:mm");
    workingTimeEnd.value = moment(workingTime.value.end).format("HH:mm");
  }
};

const getNewestWorkingTime = async (userId) => {
    try {
    workingTimeLoading.value = true;
    const result = await instance.get(`/workingtimes/${userId}`); 
    workingTime.value.id = result.data[0].id;
    workingTime.value.start = result.data[0].start;
    workingTime.value.end = result.data[0].end;
    } catch (err) {
        console.log(err)
        workingTimeError.value = "Failed to fetch working time";
    } finally {
    workingTimeLoading.value = false;
    workingTimeDay.value = moment(workingTime.value.start).format("MMMM Do YYYY");
    workingTimeStart.value = moment(workingTime.value.start).format("HH:mm");
    workingTimeEnd.value = moment(workingTime.value.end).format("HH:mm");
  }
}

watch(() => route.params.userId, route.params.workingTimeId, getWorkingTime);
onMounted(() => {
  getWorkingTime(route.params.userId, route.params.workingTimeId);
});
</script>

<template>
  <div class="mx-auto my-2 w-[380px]">
    <div class="rounded-md bg-zinc-100 p-4 shadow">
      <div v-if="workingTimeLoading" class="flex items-center gap-x-2">
        <Loader2 class="size-4 animate-spin" />
        <span>Loading...</span>
      </div>

      <div v-else-if="workingTimeError">
        {{ workingTimeError }}
      </div>
      <div v-else-if="!workingTimeError">
        <Card class="w-[350px]">
          <CardHeader>
            <CardTitle>Working Time</CardTitle>
            <CardDescription>{{ workingTimeDay }}</CardDescription>
          </CardHeader>
          <CardContent>
            <div class="timesContainer">
              <h4 class="time">Entry time : {{ workingTimeStart }}</h4>
              <Separator class="separator" orientation="vertical" />
              <h4 class="time">Exit time : {{ workingTimeEnd }}</h4>
            </div>
          </CardContent>
          <CardFooter class="flex justify-between px-6 pb-6">
            <EditWorkingTimeDialog
              :workingTime="workingTime"
              :onSuccess="() => getWorkingTime(route.params.userId, route.params.workingTimeId)"
            >
              <Button variant="outline"> Edit </Button>
            </EditWorkingTimeDialog>
            <DeleteWorkingTimeDialog
              :workingTime="workingTime"
              :onSuccess="() => getNewestWorkingTime(route.params.userId)"
            >
              <Button variant="destructive"> Delete </Button>
            </DeleteWorkingTimeDialog>
          </CardFooter>
        </Card>
      </div>
    </div>
  </div>
</template>

<style>
.timesContainer {
  display: flex;
  justify-content: space-evenly;
}

.separator {
  height: 100%;
}
</style>
