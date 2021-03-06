﻿using Capstone.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Capstone.Web.DAL
{
	public interface IProjectDAL
	{
		ProjectModel GetProjectByHouseId(int houseId);
		int AddNewHouse(ProjectModel model);
		List<ProjectModel> GetUserProjects(Guid userId);
        void DeleteProject(int projectId);

	}

}
