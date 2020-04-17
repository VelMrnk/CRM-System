<?php

namespace App\Namer;

use Vich\UploaderBundle\Mapping\PropertyMapping;
use Vich\UploaderBundle\Naming\DirectoryNamerInterface;

class ImageDirectoryNamer implements DirectoryNamerInterface
{
    /**
     * Returns the name of a directory where files will be uploaded
     *
     * Directory name is formed based on ID and media type
     *
     * @param $imageObject
     * @param PropertyMapping $mapping
     *
     * @return string
     */
    public function directoryName($imageObject, PropertyMapping $mapping) : string
    {
        return $this->getDirName($imageObject);
    }

    /**
     * @param $imageObject
     * @return string
     */
    public function getDirName($imageObject)
    {
        $client = method_exists($imageObject, 'getClient') ? $imageObject->getClient() : null;
        $path = $client ? ('client/' . $client->getId() . '/') : 'software/';

        return $path;
    }
}