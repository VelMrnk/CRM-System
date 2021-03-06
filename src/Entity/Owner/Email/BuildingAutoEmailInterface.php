<?php

namespace App\Entity\Owner\Email;

use App\Entity\Building\Building;

interface BuildingAutoEmailInterface
{
    /**
     * @return Building
     */
    public function getBuilding() : Building;

    /**
     * @param Building $building
     */
    public function setBuilding(Building $building);
}
