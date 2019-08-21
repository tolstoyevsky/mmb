//  Description:
//    Script for updating username in hubot brain that resolves bug with outdated username.
//  Author:
//    BehindLoader

const schedule = require('node-schedule')

const BRAIN_UPDATER_SCHEDULER = process.env.BRAIN_UPDATER_SCHEDULER || '0 0 7 * * *'

/**
 * Get a list of all users on a remote server.
 *
 * @param {HubotRobot} robot - Hubot instance.
 * @returns {Array<HubotUser>}
 */
async function _getAllRemoteUsers (robot) {
  const usersList = []

  const firstPageOffset = 0
  const usersPerPage = 100
  const options = {
    offset: firstPageOffset,
    count: usersPerPage
  }

  while (true) {
    const apiUsersList = await robot.adapter.api.get('users.list', options)

    if (!apiUsersList.users.length) break

    usersList.push(...apiUsersList.users)
    options.offset += usersPerPage
  }

  return usersList
}

/**
 * Periodic task that updates username in hubot brain.
 *
 * @param {HubotRobot} robot - Hubot instance.
 * @returns {undefined}
 */
async function taskUpdateBrain (robot) {
  const remoteUsers = await _getAllRemoteUsers(robot)

  remoteUsers.forEach(apiUser => {
    const apiUserId = apiUser._id
    const localUser = robot.brain.data.users[apiUserId]

    if (localUser) {
      if (localUser.name !== apiUser.username) { // Database updating optimization
        localUser.name = apiUser.username
      }
    }
  })
}


/**
 * @argument {HubotRobot} robot
 */
module.exports = (robot) => {
  // Running periodic task for updaing user data in hubot brain.
  schedule.scheduleJob(BRAIN_UPDATER_SCHEDULER, () => taskUpdateBrain(robot))
}
