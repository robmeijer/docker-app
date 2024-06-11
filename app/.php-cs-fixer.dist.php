<?php

$finder = (new PhpCsFixer\Finder())
    ->in(__DIR__)
    ->exclude('var')
;

return (new PhpCsFixer\Config())
    ->setRules([
        '@PER-CS' => true,
    ])
    ->setCacheFile(__DIR__ . '/var/php-cs-fixer/.php-cs-fixer.cache')
    ->setFinder($finder)
;
