<!-- eslint-disable prettier/prettier -->
<script setup>
import moment from "moment";
import { Edit3, Loader2, Plus, Trash2, Undo, User2 } from "lucide-vue-next";
import { onMounted, ref, watch } from "vue";
import { useRoute, useRouter } from "vue-router";

import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'
import { Separator } from "@/components/ui/separator";

import { instance } from "../../api/instance";
import EditWorkingTimeDialog from "./EditWorkingTimeDialog.vue";
import DeleteWorkingTimeDialog from "./DeleteWorkingTimeDialog.vue";
import CreateWorkingTimeDialog from './CreateWorkingTimeDialog.vue';

const route = useRoute();
const router = useRouter();

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
    console.log("get called")
    console.log(userId, workingTimeId)
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
   // workingTimeLoading.value = true;
    const result = await instance.get(`/workingtimes/${userId}`); 
    router.push(`/${userId}/${result.data[0].id}`);
    } catch (err) {
        console.log(err)
        workingTimeError.value = "Failed to fetch working time";
    }
}
watch(() => route.params.workingTimeId,
(oldId, newId) => {
    console.log("fetch new trig")
    getWorkingTime(route.params.userId, route.params.workingTimeId);

})

onMounted(() => {
  getWorkingTime(route.params.userId, route.params.workingTimeId);
});
</script>

<template>
  <div class="mx-auto my-2 w-[430px]">
    <div class="rounded-md bg-zinc-100 p-4 shadow">
      <div v-if="workingTimeLoading" class="flex items-center gap-x-2">
        <Loader2 class="size-4 animate-spin" />
        <span>Loading...</span>
      </div>

      <div v-else-if="workingTimeError">
        {{ workingTimeError }}
      </div>
      <div v-else-if="!workingTimeError">
        <Card class="w-[400px]">
          <CardHeader>
            <CardTitle>Working Time</CardTitle>
            <CardDescription>{{ workingTimeDay }}</CardDescription>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead class="text-center"> Entry time </TableHead>
                  <TableHead class="text-center">Exit time</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                <TableRow>
                  <TableCell class="text-center font-medium">
                    {{ workingTimeStart }}
                  </TableCell>
                  <TableCell class="text-center font-medium">
                    {{ workingTimeEnd }}
                  </TableCell>
                </TableRow>
              </TableBody>
            </Table>
          </CardContent>
          <CardFooter class="flex justify-between px-6 pb-6">
            <CreateWorkingTimeDialog
              :on-success="
                () =>
                  getWorkingTime(
                    route.params.userId,
                    route.params.workingTimeId
                  )
              "
            >
              <Button variant="secondary">
                <Plus class="size-4" />
                Add new
              </Button>
            </CreateWorkingTimeDialog>
            <EditWorkingTimeDialog
              :working-time="workingTime"
              :on-success="
                () =>
                  getWorkingTime(
                    route.params.userId,
                    route.params.workingTimeId
                  )
              "
            >
              <Button variant="outline">
                <Edit3 class="size-4" />
                Edit
              </Button>
            </EditWorkingTimeDialog>

            <DeleteWorkingTimeDialog
              :working-time="workingTime"
              :on-success="() => getNewestWorkingTime(route.params.userId)"
            >
              <Button variant="destructive">
                <Trash2 class="size-4" />
                Delete
              </Button>
            </DeleteWorkingTimeDialog>
          </CardFooter>
        </Card>
      </div>
    </div>
  </div>
</template>
